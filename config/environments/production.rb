Rails.application.configure do
  config.cache_classes = true # Code is not reloaded between requests.
  config.eager_load = true # Eager load code on boot.

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false
  config.assets.digest = true

  config.log_level = :debug

  # Production email settings: send via Sendgrid, generate URLs with our hostname
  config.action_mailer.default_url_options = { host: 'www.local-welcome.org' }
  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: '587',
    authentication: :plain,
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    domain: 'heroku.com',
    enable_starttls_auto: true
  }

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify # Send deprecation notices to registered listeners.

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  config.active_record.dump_schema_after_migration = false
end
