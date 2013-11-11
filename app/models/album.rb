class Album < ActiveRecord::Base
  attr_accessible :image_url, :name, :network, :social_network_id

  acts_as_taggable

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item
  has_one :content_control, :as => :itemizable, :dependent => :destroy

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

  has_many :photo_albums, :dependent => :destroy
  has_many :photos, :through => :photo_albums, :extend => ContentControlLinkedToUser

  def to_param
    if name
      "#{id}-#{name.parameterize}"
    else
      id
    end
  end

  def build_feed
    FriendFeed.create_friend_feed playlist.user, name, network, 'album', item, image_url
  end

  # can not delete photos by deleting photo_albums
  def delete_self
    self.photos.each {|photo| photo.delete }
    self.photo_albums.delete_all
    self.delete
  end

end
