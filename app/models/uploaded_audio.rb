require 'open-uri'
require 'stringio'
require 'net/http'
require 'uri'
require 'mp3info'

class UploadedAudio < ActiveRecord::Base
  attr_accessible :panda_audio_id, :title, :user_id, :artist, :album, :genre, :music_photo
  validates_presence_of :panda_audio_id

  belongs_to :user

  after_destroy { panda_audio.delete }

  has_one :item, :as => :itemizable, :dependent => :destroy
  has_one :playlist, :through => :item
  has_one :content_control, :as => :itemizable, :dependent => :destroy

  acts_as_taggable

  def image_url
    "https://a1.sndcdn.com/images/default_avatar_large.png?3eddc42"
  end

  def music_url
    original_audio = panda_audio.encodings["mp3"]
    original_audio.url rescue nil
  end

  def panda_audio
    @panda_audio ||= Panda::Video.find(panda_audio_id)
  end

  def encode_success?
    panda_audio.encodings["mp3"].status == "success"
  end

  def ori_audio_url
    panda_audio.encodings["mp3"].url
  end

  def fetch_meta
    url = URI.parse(self.panda_audio.url)
    http = Net::HTTP.new(url.host, url.port)
    req = Net::HTTP::Get.new(url.path) # init a request with the url
    #req.range = (0..40960) # limit the load to only 4096 bytes
    res = http.request(req) # load the mp3 file
    child = {} # prepare an empty hash to store the metadata we grab
    Mp3Info.open(StringIO.open(res.body)) do |m|  #do the parsing
      child['title'] = m.tag.title
      child['artist'] = m.tag.artist
      child['album'] = m.tag.album
      child['genre'] = m.tag.genre_s

      #Cover Art
      pictures = m.tag2.pictures # array of images
      unless pictures.empty?
        pic = pictures[0]
        desc, data = pic[0], pic[1]
        file_name = "uploaded_audio_#{id}_#{desc}"
        File.binwrite(file_name, data)
        child['music_photo'] = File.new(file_name, "r")
      end
    end

    add_to_album child['album']


    # update uploaded_audio
    self.update_attributes child
    # delete temp file
    File.delete(child['music_photo'].path) if child['music_photo']
  end


  def add_to_album album_name
    user = self.user
    playlist = user.music_playlists.where(:social_network => 'Upload').first
    album_name ||= "Unknown" if album_name.empty?

    album = playlist.collections.where(:title => album_name).first_or_initialize
    if album.new_record?
      album.save!
      playlist.collections << album
    end


    album.uploaded_audios << self
  end

  unless Rails.env.development?
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://66.228.51.151:83",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/music_photo/:id/:style/:basename.:extension"
    }
  else
    paperclip_opts = {
        :storage => :fog,
        :fog_credentials => {:provider => "Local", :local_root => "public"},
        :fog_directory => "",
        :fog_host => "http://localhost:3000",
        :styles => Proc.new { |clip| clip.instance.styles },
        #:url  => "/assets/vehicles/:id/:style/:basename.:extension",
        :path => "system/music_photo/:id/:style/:basename.:extension"
    }
  end


  has_attached_file :music_photo, paperclip_opts

  def styles
    {}
  end

end
