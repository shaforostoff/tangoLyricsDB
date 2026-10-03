# Only our own scripts (with a per-session nonce for the inline importmap/Chartkick
# scripts) and the pinned jsDelivr files may run.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.script_src  :self, "https://cdn.jsdelivr.net"
    policy.style_src   :self, "https://cdn.jsdelivr.net"
    # Chartkick and the footer icons use style attributes
    policy.style_src_attr :unsafe_inline
    policy.font_src    :self, "https://cdn.jsdelivr.net"
    # Bootstrap draws some icons from data: SVGs
    policy.img_src     :self, :data
    policy.connect_src :self
    policy.object_src  :none
    policy.base_uri    :self
    policy.form_action :self
    policy.frame_ancestors :none
  end

  # A per-session nonce stays valid across Turbo page visits
  config.content_security_policy_nonce_generator = ->(request) { request.session[:csp_nonce] ||= SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end
