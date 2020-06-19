class Post < ApplicationRecord
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :youtube_url, presence: true
  validate :validate_youtube_url

  before_save :scrape_page

  def youtube_code
    @youtube_code ||= CGI.parse(URI.parse(youtube_url).query)['v'].first
  end

  def embed_url
    "https://www.youtube.com/embed/#{youtube_code}"
  end

  private

    def scrape_page
      info = ::FetchYoutubeVideoInfo.new(youtube_url).call
      self.title = info[:title]
      self.description = info[:description]
    end

    def validate_youtube_url
      youtube_url.present? && URI.parse(youtube_url)
    rescue URI::InvalidURIError
      self.errors['youtube_url'] << 'must be a valid URL'
    end
end
