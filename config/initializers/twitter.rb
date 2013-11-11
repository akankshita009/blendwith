Twitter.configure do |config|
  config.consumer_key = CONFIG[:twitter][:consumer_key]
  config.consumer_secret = CONFIG[:twitter][:consumer_secret]
end
