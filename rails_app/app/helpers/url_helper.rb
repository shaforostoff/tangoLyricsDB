require "net/http"

module UrlHelper
  # Returns true if the link looks alive, false if it is gone, nil if it could not be checked
  def check_url(url)
    uri = URI.parse(url)
    response = nil
    begin
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 5, read_timeout: 5) do |http|
        response = http.head(uri.request_uri)
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
  end
end
