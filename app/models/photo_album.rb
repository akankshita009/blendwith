class PhotoAlbum < ActiveRecord::Base
  belongs_to :photo
  belongs_to :album
  # attr_accessible :title, :body
end
