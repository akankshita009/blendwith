Blendwith::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  #config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false

  #config.action_mailer.default_url_options = { :host => 'li293-151.members.linode.com:83' }
    config.action_mailer.default_url_options = { :host => 'www.itcoders.com' }

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp

=begin config.action_mailer.smtp_settings = {
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
=begin    config.action_mailer.smtp_settings = {
	:openssl_verify_mode  => 'none',
	:tls 					=> false,
	:enable_starttls_auto => false,
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :domain               => 'gmail.com',
    :authentication       => 'plain',
    :user_name            => 'sandboxtest1987@gmail.com',
    :password             => 'sandboxtest1987'
    



    
  }
=end
end
