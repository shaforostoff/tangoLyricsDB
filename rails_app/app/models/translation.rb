class Translation < ApplicationRecord
  include Filterable
  include UrlHelper
  include YoutubeHelper
  
  belongs_to :song, counter_cache: true, optional: true
  belongs_to :language, counter_cache: true, optional: true
  belongs_to :translator, counter_cache: true, optional: true
  
  # Scopes
  # Next line overrides scoping in song Model, hence commented out
  # default_scope { order('created_at') }
  
  scope :language_is, -> (language_id) { where("language_id = ?", language_id) } 
  scope :translator_is, -> (translator_id) { where("translator_id = ?", translator_id) } 
  
  # Validations
  validates :link,
  presence: true,
  length: { minimum: 15 },
  url: true, # Custom URL validator in app/validators
  uniqueness: { case_sensitive: false, :scope => [ :language_id, :song_id ], message: "+ language combination must be unique" } # Sometimes a page may contain several translations (in different languages)
  
  validates :language_id,
  presence: true,
  numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    
  # Callbacks
  before_validation :normalise_translation, on: [ :create, :update ]
  before_validation :attach_youtube_channel, on: [ :create, :update ], if: :link_changed?
  after_validation :define_translator, :check_link
  
  def self.save_all
    # Useful to check that all translations are valid
    Translation.all.each { |translation| translation.save! }
  end
  
  protected
  def check_link
    self.active = check_url(self.link) unless self.link.blank?
  end
  
  def normalise_translation
    # Remove white space, replace https with http, unescape "#" character
    unless self.link.blank?
      self.link = self.link.strip
      self.link = URI::RFC2396_PARSER.escape(URI::RFC2396_PARSER.unescape(self.link))
      #self.link = self.link.gsub('https', 'http')
      self.link = self.link.gsub('%23', '#') # Hash incorrectly rendered
      self.link = self.link.gsub('%20', '') # %20 sign creeping into links (e.g. YouTube links split at "=" sign)
    end
  end
  
  def attach_youtube_channel
    # Store YouTube videos under their channel, so the channel's translator (created if new) is found
    video_id, params = self.link.to_s.match(VIDEO_LINK)&.captures
    return unless video_id

    channel = youtube_channel(video_id)
    return unless channel

    channel_link = "https://www.youtube.com/channel/#{channel[:id]}"
    self.link = "#{channel_link}/watch?v=#{video_id}#{"&#{params}" if params.present?}"
    unless Translator.unscoped.where("site_link LIKE ?", "%youtube.com/channel/#{channel[:id]}%").exists?
      Translator.create(name: channel[:name], site_name: "#{channel[:name]} (YouTube)", site_link: channel_link)
    end
  end

  def define_translator
    # Check which translator this translation belongs to
    @translators = Translator.all
    unless self.link.blank?
      @translators.each do |t|
        if self.link.include?(t.site_link)
          self.translator_id = t.id
        end
      end
    end
  end
end
