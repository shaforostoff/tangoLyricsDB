require "net/http"
require "json"

module YoutubeHelper
  # A bare video link (youtube.com/watch?v=, youtu.be/, /shorts/), without the channel prefix
  VIDEO_LINK = %r{\Ahttps?://(?:(?:www\.|m\.)?youtube\.com/(?:watch\?(?:.*&)?v=|shorts/)|youtu\.be/)([\w-]{11})(?:[?&](.*))?\z}

  # The video's channel as { id:, name: }, or nil if it could not be found
  def youtube_channel(video_id)
    page = youtube_get("https://www.youtube.com/watch?v=#{video_id}")
    channel_id = page && page[/"videoDetails":\{.*?"channelId":"(UC[\w-]{22})"/m, 1]
    return nil unless channel_id

    oembed = youtube_get("https://www.youtube.com/oembed?format=json&url=https://www.youtube.com/watch?v=#{video_id}")
    name = oembed && JSON.parse(oembed)["author_name"].presence
    name ||= page[/"ownerChannelName":"((?:[^"\\]|\\.)*)"/, 1]&.then { |raw| JSON.parse(%("#{raw}")) }
    { id: channel_id, name: name }
  rescue JSON::ParserError
    nil
  end

  private

  def youtube_get(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 5
    http.read_timeout = 5
    # The cookie skips the EU consent page
    response = http.get(uri.request_uri, "Accept-Language" => "en", "Cookie" => "SOCS=CAI", "User-Agent" => "Mozilla/5.0")
    response.body.force_encoding(Encoding::UTF_8) if response.is_a?(Net::HTTPSuccess)
  rescue => e
    Rails.logger.warn "YoutubeHelper error #{e}"
    nil
  end
end
