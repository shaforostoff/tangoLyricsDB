# Devise uses secret_key_base (SECRET_KEY_BASE env var) for its tokens.
Devise.setup do |config|
  config.mailer_sender = "tangotranslation@gmail.com"

  require "devise/orm/active_record"

  # Don't reveal whether an email address has an account
  config.paranoid = true

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

# Slow down password guessing and reset-email abuse
Rails.application.config.to_prepare do
  Devise::SessionsController.rate_limit to: 10, within: 3.minutes, only: :create
  Devise::PasswordsController.rate_limit to: 5, within: 1.hour, only: :create
end
