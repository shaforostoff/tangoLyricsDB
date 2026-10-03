require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.cache_store = :memory_store, { size: 16.megabytes }

  # YJIT costs ~30 MB of RAM; pages render in a few ms without it
  config.yjit = ENV["RAILS_YJIT"] == "true"

  # Digest-stamped assets can be cached forever.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Thruster terminates TLS once TLS_DOMAIN is set; before that the site is plain HTTP.
  config.assume_ssl = ENV["TLS_DOMAIN"].present?
  config.force_ssl = ENV["TLS_DOMAIN"].present?
  config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  config.action_mailer.default_url_options = { host: ENV.fetch("CANONICAL_HOST", "tangotranslations.org"), protocol: ENV["TLS_DOMAIN"].present? ? "https" : "http" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV.fetch("GMAIL_DOMAIN", "gmail.com"),
    authentication: :plain,
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
  }

  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
end
