class ProfilePhoto < ActiveRecord::Base
  belongs_to :user
  attr_accessible :profile_photo

  validates_attachment_presence :profile_photo, :if => lambda { |photo| !photo.profile_photo_file_name.nil?}
  validates_attachment_size :profile_photo, :less_than => 5.megabyte
  validates_attachment_content_type :profile_photo, :content_type => ['image/pjpeg', 'image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  unless Rails.env.development?
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://66.228.51.151:83",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/profile_photos/:id/:style/:basename.:extension"
    }
  else
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://localhost:3000",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/profile_photos/:id/:style/:basename.:extension"
    }
  end


  has_attached_file :profile_photo, paperclip_opts

  after_create :reprocess

  def styles
    {:medium => ['80X80#', :png], :thumb => ['40x40#', :png]}
  end


  private

  def reprocess
    #todo add condition for events
    self.profile_photo.reprocess!
  end
end
