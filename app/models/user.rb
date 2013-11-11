class User < ActiveRecord::Base
  opinio_subjectum
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name,  :last_name, :username, :no_need_confirm,
    :location, :player_title, :player_description, :provider, :uid, :approved

  after_create :init_social_playlist, :init_player_token, :create_friend_list


  default_scope { where(:deleted_at => nil) }



  def to_s
    "#{first_name} #{last_name}".titleize
  end

  def self.filter_auth_params(conditions)
    conditions
  end

  def soft_delete
    self.update_attribute(:deleted_at, Time.now)
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

  has_many :image_items, :through => :image_playlists, :source =>:items
  has_many :music_items, :through => :music_playlists, :source =>:items
  has_many :video_items, :through => :video_playlists, :source =>:items

  has_many :players, :dependent => :destroy
  has_many :playlists, :dependent => :destroy
  has_many :image_playlists, :dependent => :destroy
  has_many :music_playlists, :dependent => :destroy
  has_many :video_playlists, :dependent => :destroy
  has_many :photo_urls, :dependent => :destroy,  :extend => ContentControlLinkedToUser
  has_many :video_urls, :dependent => :destroy
  has_many :music_urls, :dependent => :destroy
  has_many :uploaded_photos, :dependent => :destroy,  :extend => ContentControlLinkedToUser
  has_many :uploaded_videos, :dependent => :destroy
  has_many :uploaded_audios, :dependent => :destroy
  has_many :services, :dependent => :destroy
  has_one :cover_photo, :dependent => :destroy
  has_one :profile_photo, :dependent => :destroy
  [:facebook, :instagram, :twitter, :flickr, :soundcloud].each do |service|
    has_one service, :conditions => { :services => { :provider => service.to_s } }, :class_name => "Service"
  end
  has_one :youtube, :conditions => { :services => { :provider => "google_oauth2", :google_service => 'youtube'} }, :class_name => "Service"
  has_one :picasa, :conditions => { :services => { :provider => "google_oauth2", :google_service => 'picasa'} }, :class_name => "Service"

  has_many :friend_maps, :foreign_key => "user_id"
  has_many :friend_maps_reverse, :foreign_key => "friend_id", :class_name => "FriendMap"

  has_many :friend_feeds, :dependent => :destroy
  has_many :content_controls


  #validates :username, :presence => true
  validates_uniqueness_of :username, :allow_blank => true, :on => :update

  # inner message
  acts_as_messageable


  EMBED_PLAYER_PRIVACY = [
    ['Just Me', 0], ['Share With Friends', 1], ['Public', 2]
  ]

  [:just_me, :just_friends, :public].each_with_index do |method_name, index|
    define_method "#{method_name}?" do
      self.embed_code_privacy === index
    end
  end

  def allowed_to_embed_player?(current_user)
    return true if self.public?
    if current_user.present?
      if self.just_me?
        return current_user.id == self.id
      elsif self.just_friends? 
        return self.friend_maps.pluck(:friend_id).include? current_user.id || current_user.id == self.id
      end
    end
    false
  end

  class << self

    def find_or_create_from_omniauth(auth)
      info = auth['info']
      password = Devise.friendly_token[0,10]
      user_attr = { username: info['nickname'], first_name: info['first_name'], last_name: info['last_name'] }
      user = where(email: info['email']).first_or_create(user_attr.merge(password: password, password_confirmation: password))
      return user if user.persisted? && user.deleted_at?
      return if user.new_record?

      user.add_or_update_social_service_from_omniauth(auth)
      user
    end

    #---delete--- check email, generate a random email if blank, otherwise use the email given
    # not generate email if email is blank
    def create_from_twitter(auth, email, twitter_user_id)
      password = Devise.friendly_token[0,10]
      names = auth[:info][:name].split(',')
      user_attr = {username: auth[:info][:nickname], first_name: names[0], last_name: names[1], password: password,
        password_confirmation: password, provider: auth[:provider], uid: auth[:uid]}
      user = User.find_by_provider_and_uid(auth[:provider], auth[:uid])
      # actually, the user must be nil
      unless user
        #email = "#{Devise.friendly_token[0,10]}@example.com" if email.blank?
        user = User.new(user_attr.merge(email: email))
        if user.save
          TwitterUser.find(twitter_user_id).delete
          user.update_attribute :email, "twitter-user#{user.id}@blendwith.com" if email.blank?
          user.add_or_update_social_service_from_omniauth(auth)
        end
      end
      user
    end
  end

  def add_or_update_social_service_from_omniauth(auth, google_service = nil)
    access_token = auth['credentials']['token']
    expires_at = auth['credentials']['expires_at']
    expires_at = Time.at(expires_at) if expires_at

    if google_service
      service = self.services.where(uid: auth['uid'].to_s, provider: auth['provider'], google_service: google_service).first_or_create(access_token: access_token)
    else
      service = self.services.where(uid: auth['uid'].to_s, provider: auth['provider']).first_or_create(access_token: access_token)
    end
    self.profile_photo_from auth['info']['image'] if service.provider.in?(['facebook', 'twitter'])
    data = HashWithIndifferentAccess.new(auth)
    service.update_attributes(access_token: access_token, data: data, expires_at: expires_at)
    if google_service
      # if there are refresh token, just save it
      # otherwise fetch the refresh token of youtube/G+
      #s.data['credentials']['refresh_token']
      if refresh_token = data['credentials']['refresh_token']
        service.update_attribute :refresh_token, refresh_token
      else
        youtube_refresh_token = self.youtube.data['credentials']['refresh_token'] if self.youtube
        picasa_refresh_token = self.picasa.data['credentials']['refresh_token'] if self.picasa
        refresh_token = youtube_refresh_token || picasa_refresh_token
        service.update_attribute :refresh_token, refresh_token if refresh_token
      end
    end
    self
  end

  def add_friend friend_id
    if self.friend_maps.where(friend_id: friend_id).count == 0
      friend = User.find(friend_id)
      confirmed = friend.no_need_confirm
      self.friend_maps.create!(friend_id: friend_id, is_confirmed: confirmed)
      # send inner message if need permission
      unless confirmed
        AdminUser.first.send_message(friend, "#{final_username} send you a <a href='/friend_maps?request_friends=true'>friend request</a>. <br /> This is a system generated mail. Please do not reply.",
          "#{final_username} send you a friend request.")
      end
      confirmed ? "friend" : "pending"
    else
      if self.friend_maps.where(friend_id: friend_id).first.is_confirmed
        "already"
      else
        "pending"
      end
    end
  end

  def agree_request user_id
    map = self.friend_maps_reverse.where(user_id: user_id).first
    if map
      map.update_attribute(:is_confirmed, true)
      "friend"
    else
      "wrong"
    end
  end

  def new_comment
    self.update_attribute :comment_count, (self.comment_count + 1)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def final_username
    self.full_name.blank? ? self.username : self.full_name
  end

  def is_friend_of user
    friend_ids = user.friend_maps.map {|map| map.friend.id }
    friend_ids.include? self.id
  end

  def init_social_playlist
    # image playlist
    %w(Facebook Twitter Instagram Flickr Picasa URL MyPhotos).each do |social|
      self.image_playlists.create(name: social, social_network: social)
    end
    self.image_playlists.create(name: "All Photos", social_network: "AllPhotos")
    self.image_playlists.create(name: "Recent Photos", social_network: "RecentPhotos")
    # video playlist
    self.video_playlists.create(name: 'Youtube', social_network: 'Youtube')
    # audio playlist
    self.music_playlists.create(name: 'Soundcloud', social_network: 'Soundcloud')
  end

  def init_player_token
    token = Devise.friendly_token[0,10]
    self.update_attribute :player_token, token
  end
  
  def create_friend_list
    email = "punkrocker04@gmail.com"
    default_user = User.where(:email => email).first
    if default_user
      default_user
    else
      create_user = User.create!(:first_name => "Albert", :last_name => "Contreras", :email => "#{email}",
                 :password => "12345678", :password_confirmation => "12345678", :no_need_confirm => true)
      default_user = create_user
    end
    
    self.agree_request(default_user.id)
    self.add_friend(default_user.id)
  end

  def all_photos_playlist_id
    @all_photos_playlist_id ||= self.image_playlists.where(social_network: 'AllPhotos').first.id
  end

  def recent_photos_playlist_id
    @recent_photos_playlist_id ||= self.image_playlists.where(social_network: 'RecentPhotos').first.id
  end

  def mailboxer_email(object)
    email
  end

  def un_read_message_count
    receipts.where(is_read: false).count
  end

  def profile_photo_from url
    if self.profile_photo.nil?
      self.create_profile_photo(:profile_photo => open(url))
    end
  end


end
