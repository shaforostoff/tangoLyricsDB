# Devise uses secret_key_base (SECRET_KEY_BASE env var) for its tokens.
Devise.setup do |config|
  config.mailer_sender = "tangotranslation@gmail.com"

  require "devise/orm/active_record"

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth ]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  # Turbo expects these statuses for failed form submissions and redirects.
  config.responder.error_status = :unprocessable_content
  config.responder.redirect_status = :see_other
end
