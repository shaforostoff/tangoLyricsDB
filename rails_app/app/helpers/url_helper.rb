require "net/http"
require "resolv"
require "ipaddr"

module UrlHelper
  # Ranges a link check must never reach, beyond what IPAddr#private?/loopback?/link_local? cover:
  # "this network", carrier-grade NAT, IETF protocol assignments, benchmarking, multicast and reserved.
  BLOCKED_RANGES = %w[0.0.0.0/8 100.64.0.0/10 192.0.0.0/24 198.18.0.0/15 224.0.0.0/3].map { |r| IPAddr.new(r) }.freeze

  # Returns true if the link looks alive, false if it is gone, nil if it could not be checked
  def check_url(url)
    uri = URI.parse(url)
    return nil unless uri.is_a?(URI::HTTP) && uri.host.present? && [ 80, 443 ].include?(uri.port)

    # Anyone can trigger a check, so it must never reach the VM itself or private networks.
    # Connecting to the address that was vetted also defeats DNS rebinding.
    address = public_address(uri.host)
    return nil unless address

    response = nil
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.ipaddr = address
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = 5
      http.read_timeout = 5
      http.start do |connection|
        response = connection.head(uri.request_uri)
        Rails.logger.debug "UrlHelper::check_url #{response}"
      end
    rescue => e
      Rails.logger.warn "UrlHelper::check_url error #{e}"
      return nil
    end

    if response.is_a?(Net::HTTPRedirection)
      # 303 is often used for redirects to the translation itself
      return response.code == "303"
    end

    response.code != "404"
  rescue URI::InvalidURIError
    nil
  end

  # The host's IPv4 address if every address it resolves to is public, otherwise nil
  def public_address(host)
    addresses = Resolv.getaddresses(host).map { |a| IPAddr.new(a) }
    return nil if addresses.empty? || addresses.any? { |ip| !public_ip?(ip) }

    # The VM has no IPv6 connectivity
    addresses.find(&:ipv4?)&.to_s
  rescue IPAddr::InvalidAddressError, Resolv::ResolvError
    nil
  end

  private

  def public_ip?(ip)
    ip = ip.native # IPv4-mapped IPv6 addresses are checked as IPv4
    !(ip.private? || ip.loopback? || ip.link_local? || BLOCKED_RANGES.any? { |range| range.include?(ip) } ||
      (ip.ipv6? && (ip.to_s == "::" || IPAddr.new("fc00::/7").include?(ip))))
  end
end
