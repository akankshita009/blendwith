class Item < ActiveRecord::Base
  belongs_to :itemizable, :polymorphic => true
  belongs_to :playlist, :counter_cache => true

  scope :association_includer, lambda { includes(:itemizable => [:tags, :content_control]).order("items.created_at DESC") }
  scope :with_playlist, lambda { |playlist| where(:playlist_id => playlist.id) }
  scope :with_playlists, lambda { |playlists| where(:playlist_id => playlists.map(&:id)) }
  
  attr_accessible :photo
  # attr_accessible :title, :body
end
