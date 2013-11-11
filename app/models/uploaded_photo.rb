class UploadedPhoto < ActiveRecord::Base
  belongs_to :user
  attr_accessible :image
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  def image_url
    self.image.url
  end

  after_create  :add_to_playlist
  def add_to_playlist
    playlist = user.image_playlists.where(social_network: 'MyPhotos').first_or_create(:name => "Uploaded Photos")
    playlist.uploaded_photos << self
  end

  acts_as_taggable
  
  validates_attachment_presence :image, :if => lambda { |images| !images.image_file_name.nil?}
  validates_attachment_size :image, :less_than => 5.megabyte
  validates_attachment_content_type :image, :content_type => ['image/pjpeg', 'image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  #unless Rails.env.development?
  #  paperclip_opts = {:storage => :s3,
  #                    :s3_credentials => "#{Rails.root}/config/s3.yml",
  #                    :path => "/:id/:style/:basename.:extension",
  #                    :styles => Proc.new { |clip| clip.instance.styles }}
  #else
  #  paperclip_opts = {
  #      :storage => :fog,
  #      :fog_credentials => {:provider => "Local", :local_root => "#{Rails.root}/public"},
  #      :fog_directory => "",
  #      :fog_host => "http://localhost:3000",
  #      :styles => Proc.new { |clip| clip.instance.styles },
  #  }
  #end
  
  unless Rails.env.development?
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://66.228.51.151:83",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/images/:id/:style/:basename.:extension"
    }
  else
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://localhost:3000",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/images/:id/:style/:basename.:extension"
    }
  end
  
  has_attached_file :image, paperclip_opts

  after_create :reprocess

  def styles
    {:thumb => ['285x175#', :png]}
    #{:medium => ['100X100#', :png], :thumb => ['60x60#', :png]}
  end

  private

  def reprocess
    #todo add condition for events
    self.image.reprocess!
  end

end
