class ImagePlaylist < Playlist

  with_options :through => :items, :source => :itemizable, :extend => ContentControlLinkedToUser do |assoc|

    assoc.has_many :photos, :source_type => "Photo"
    assoc.has_many :albums, :source_type => "Album"
    assoc.has_many :photo_urls, :source_type => "PhotoUrl"
    assoc.has_many :uploaded_photos, :source_type => "UploadedPhoto"
  end
end
