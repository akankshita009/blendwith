class Playlist < ActiveRecord::Base
  belongs_to :player
  belongs_to :user
  has_many :photo_urls
  has_many :items, :dependent => :destroy do
    def allowed
      item_ids = joins("INNER JOIN content_controls ON items.itemizable_id = content_controls.itemizable_id AND items.itemizable_type = content_controls.itemizable_type").limit(12).offset(0).uniq.pluck("items.id")
      item_ids.empty? ? self : where("items.id NOT IN (?)", item_ids)
    end
  end

  module ContentControlLinkedToUser
    def allowed
      table_name = proxy_association.reflection.name
      class_name = table_name.to_s.classify
      join_query = <<-EOS 
          INNER JOIN content_controls ON content_controls.itemizable_id = #{table_name}.id
          AND content_controls.itemizable_type = '#{class_name}'
      EOS
      record_ids = joins(join_query).pluck("#{table_name}.id")
      record_ids.empty? ? self : where("#{table_name}.id NOT IN (?)", record_ids)
    end
  end


  attr_accessible :item_count, :name, :slide_show, :transition, :delay_second,
                  :background_music_id, :background_music_type, :background_music_url, :background_music_title,
                  :social_network
  attr_accessor :cover_source_id, :cover_source_class

  after_find :set_cover_source_accessors, :if => :cover_image_source?
  def set_cover_source_accessors
    klass, source_id = self.cover_image_source.to_s.split("-")
    if klass
      self.cover_source_id = source_id.to_i
      self.cover_source_class = Kernel.const_get klass
    end
  end

  validates :name, :presence => true
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  scope :association_includer, lambda { includes(:items => [:itemizable => [:content_control, :tags] ]) }

  has_attached_file :cover_image, :styles => { :thumb => "163x114#" } , :default_url => "/assets/thumb.png"

  def cover_image_from( url, media )
    self.cover_image = open(url)
    self.cover_image_source = "#{media.class}-#{media.id}"
    self.save
  rescue 
    logger.error $!.message
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end


  def add_items_from_flickr(type, object_id)
    if type === 'set'
    elsif type === 'gallery'
    elsif type === 'photo'
      images = flickr_client.photos.getSizes(photo_id: object_id)
      image = images.detect { |image| image["label"] === 'Large' } || images[images.count-1]
      photo = Photo.create(image_url: image['source'], network: 'flickr')
      self.photos << photo # unless playlist.photos.include?(photo)
      photo.build_feed
    end
  end

  def add_items_from_instagram(object_id)
    object = instagram_client.media_item(object_id)
    photo = Photo.create(image_url: object['images']['standard_resolution']['url'], network: 'instagram')
    self.photos << photo # unless playlist.photos.include?(photo)
    photo.build_feed
  end


  def add_item_from_twitter(object_id)
    tweet_id, media_id = object_id.split("_").map(&:to_i)
    puts object_id.split("_").map(&:to_i)
    tweet = twitter_client.status(tweet_id, trim_user: true)
    media = tweet.attrs[:entities][:media] and media =  media.detect { |media| media[:id] == media_id }
    photo = Photo.create(image_url: media[:media_url], network: 'twitter') if media
    self.photos << photo # unless playlist.photos.include?(photo)
    photo.build_feed
  end

  def add_items_from_picasa(type, object_id)
    if type === 'album'
      object = picasa_client.album.show(object_id)
      album = Album.create(name: object.name, image_url: object.id, network: 'picasa')
      self.albums << album # unless playlist.albums.include?(album)
      fill_picasa(album)
      album.build_feed
    elsif type == 'photo'
      object = picasa_client.photo.show(*object_id.split("_")) # wil return array of two objects last will be url for image
      photo = Photo.create(image_url: object.last, network: 'picasa')
      self.photos << photo # unless playlist.photos.include?(photo)
      photo.build_feed
    end
  end

  def add_items_from_facebook(type, object_id)
    @graph = facebook_graph
    object = @graph.get_object(object_id)
    if type === 'album'
      album = Album.create(name: object['name'], image_url: object['id'], network: 'facebook')
      self.albums << album # unless playlist.albums.include?(album)
      fill_facebook(album)
      album.build_feed
    elsif type == 'photo'
      photo = Photo.create(caption: object['name'], image_url: object['source'], network: 'facebook')
      self.photos << photo # unless playlist.photos.include?(photo)
      photo.build_feed
    end
  end
  
  def add_items_from_url(type, object_id)
    @photo_url = PhotoUrl.find(object_id)
    if type == 'photo'
      photo = Photo.create(image_url: @photo_url.image_url, network: 'url')
      self.photos << photo # unless playlist.photos.include?(photo)
      photo.build_feed
    end
  end
  
  def add_items_from_upload(type, object_id)
    @uploaded_photo = UploadedPhoto.find(object_id)
    if type == 'photo'
      photo = Photo.create(image_url: @uploaded_photo.image.url.to_s, network: 'upload')
      self.photos << photo # unless playlist.photos.include?(photo)
      photo.build_feed
    end
  end

  def add_items_from_playlist_album(object_id)
    album_from = Album.find object_id
    album_to = Album.create(name: album_from.name, image_url: album_from.image_url,
                            network: album_from.network, social_network_id: album_from.social_network_id)
    self.albums << album_to
    album_from.photos.each do |photo|
      album_to.photos << Photo.create(caption: photo.caption, image_url: photo.image_url, private: photo.private,
                                      network: photo.network, social_network_id: photo.social_network_id)
    end
    album_to.build_feed
  end

  def add_items_from_playlist_photo(object_id)
    photo_from = Photo.find object_id
    photo = Photo.create(caption: photo_from.caption, image_url: photo_from.image_url, private: photo_from.private,
                                network: photo_from.network, social_network_id: photo_from.social_network_id)
    self.photos << photo
    photo.build_feed
  end



  NAME_VALUE_HASH = {}

  %w(Facebook Twitter Instagram Flickr Picasa Youtube Soundcloud).each_with_index do |social_network, index|
    NAME_VALUE_HASH[social_network] = 100 - index
  end


  private


  def flickr_client
    service = self.user.flickr
    cred = service.data[:credentials]
    @flickr_client ||=  FlickRaw::Flickr.new
    @flickr_client.access_token = cred[:token]
    @flickr_client.access_secret = cred[:secret]
    @flickr_client
  end


  def twitter_client
    service = self.user.twitter
    cred = service.data[:credentials]
    @twitter_client ||= Twitter::Client.new(oauth_token: cred[:token], oauth_token_secret: cred[:secret])
  end

  def instagram_client
    service = self.user.instagram
    @instagram_client ||= Instagram.client(access_token: service.access_token)
  end

  def picasa_client
    service = self.user.picasa
    service.expired? and service.refresh_google_token
    email = service.data[:info][:email]
    access_token = service.access_token
    @picasa_client ||= Picasa::Client.new(user_id: email, authorization_header: "Bearer #{access_token}")
  end

  def facebook_graph
    @graph ||= Koala::Facebook::API.new(self.user.facebook.access_token)
  end

  def fill_picasa(album)
    album_id = album.image_url
    photos = picasa_client.album.show(album_id).photos
    photos.each do |photo|
      album.photos << Photo.create(image_url: photo.content.src)
    end
    photo = photos.last and album.update_attribute(:image_url, photo.content.src)
  end

  def fill_facebook(album)
    @graph = facebook_graph
    album_id = album.image_url
    photos = @graph.get_connections(album_id, 'photos', :fields => 'id, source', :limit => 0)
    photos.each do |photo|
      album.photos << Photo.create(image_url: photo['source'])
    end
    photo = photos.last and album.update_attribute(:image_url, photo['source'])
  end
end
