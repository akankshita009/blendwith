class CoverPhoto < ActiveRecord::Base
  belongs_to :user
  attr_accessible :cover_photo

  validates_attachment_presence :cover_photo, :if => lambda { |photo| !photo.cover_photo_file_name.nil?}
  validates_attachment_size :cover_photo, :less_than => 5.megabyte
  validates_attachment_content_type :cover_photo, :content_type => ['image/pjpeg', 'image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  unless Rails.env.development?
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://66.228.51.151:83",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/cover_photos/:id/:style/:basename.:extension"
    }
  else
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://localhost:3000",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/cover_photos/:id/:style/:basename.:extension"
    }
  end


  has_attached_file :cover_photo, paperclip_opts

  after_create :reprocess

  def styles
    {}
    #{:medium => ['100X100#', :png], :thumb => ['60x60#', :png]}
  end


  private

  def reprocess
    #todo add condition for events
    self.cover_photo.reprocess!
  end
end
