class RefreshOauthWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    [user.picasa, user.youtube].each do |service|
      if service && !service.disconnected && service.expired?
        service.refresh_google_token
      end  
    end
  end
end