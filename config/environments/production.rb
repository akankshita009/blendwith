  Blendwith::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( playlists.js home.js albums.js photos.js  *networks.js *playlists.js soundcloud.js jquery.fileupload-ui.js  jquery.fileupload.js collections.js
     tracks.js video_urls.js music_urls.js uploaded_videos.js uploaded_audios.js photo_urls.js friend_maps.js
    libs/jquery.easing.1.3.js libs/modernizr.js libs/selectivizr.js isotope.js common.js users.js
    plugins/audio.js plugins/player_cheage/video.js plugins/player_cheage/video-script.js active_admin.js
    plugins/screenfull.min.js track_albums.js video_albums.js conversations.js jquery-tourbus.css jquery-tourbus.min.js
    js/bootstrap.min.js js/retina.js js/jquery.backstretch.min.js js/bootstrap-lightbox.min.js js/custom.js
    plugins/player_cheage/vjs.youtube.js
    bootstrap.css bootstrap-responsive.css wuxia-orange.css)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.default_url_options = { :host => 'li293-151.members.linode.com:83' }

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp

=begin  config.action_mailer.smtp_settings = {
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 465,
      :domain => "li293-151.members.linode.com:83",
      :authentication => :login,
      :user_name => "AKIAJ7PHYDYNC3UMMZOA",
      :password => "Aiw2x3oUuPe764zQWTgkxqqa/dn8gXbTNM3+meBhlvan"
  }
=end 
config.action_mailer.smtp_settings = {
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 465,
      :domain => "www.itcoders.com",
      :authentication => :login,
      :user_name => "AKIAI2E5KADIMK5Z2AWA",
      :password => "Am6QS+PcxdIJc9hq+zLG/qafcPc4yM0glwF8zDgO5cIJ"
  }
end
