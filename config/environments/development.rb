# -*- coding: utf-8 -*-
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

#  config.after_initialize do
#    Bullet.enable = true
#    Bullet.alert = true
#    Bullet.bullet_logger = true
#    Bullet.console = true
#    #Bullet.growl = false
#    #Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
#    #                :password => 'bullets_password_for_jabber',
#    #                :receiver => 'your_account@jabber.org',
#    #                :show_online_status => true }
#    Bullet.rails_logger = true
#    #Bullet.bugsnag = true
#    #Bullet.airbrake = true
#    Bullet.add_footer = true
#    Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
#  end

  # Devise Settings
  # 以下は主にユーザのパスワード忘れの際のメール送信で利用する設定です。

  # メールに記載する本サービスのURL
  config.action_mailer.default_url_options = { :host => ENV['LODGE_DOMAIN'] }

  # SMTPの指定
  config.action_mailer.delivery_method = ENV["DELIVERY_METHOD"].to_sym
  config.action_mailer.smtp_settings = {
    :address              => ENV["SMTP_ADDRESS"],
    :port                 => ENV["SMTP_PORT"],
    :domain               => ENV["LODGE_DOMAIN"],
    :user_name            => ENV["SMTP_USERNAME"],
    :password             => ENV["SMTP_PASSWORD"],
    :authentication       => ENV["SMTP_AUTH_METHOD"].to_sym,
    :enable_starttls_auto => ENV["SMTP_ENABLE_STARTTLS_AUTO"],
  }

  config.action_mailer.smtp_settings[:openssl_verify_mode] = ENV["SMTP_OPENSSL_VERIFY_MODE"] if ENV["SMTP_OPENSSL_VERIFY_MODE"].present?
end
