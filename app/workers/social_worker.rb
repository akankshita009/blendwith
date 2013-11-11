class SocialWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    # facebook
    Service.facebook user
    # instagram
    Service.instagram user
    # flickr
    Service.flickr user
    # picasa
    Service.picasa user
    # twitter
    Service.twitter user
    # soundcloud
    Service.soundcloud user
    # youtube
    Service.youtube user
  end
end