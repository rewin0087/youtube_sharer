class Post < ApplicationRecord
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :youtube_url, presence: true
  validates :youtube_url, format: { with: URI.regexp }, if: Proc.new { |a| a.youtube_url.present? }
  validate :validate_youtube_code, if: Proc.new { |a| a.youtube_url.present? }

  before_save :scrape_page

  def youtube_code
    @youtube_code ||= CGI.parse(URI.parse(youtube_url).query.to_s)['v'].first
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

    def validate_youtube_code
      self.errors['youtube_url'] << 'has invalid video' if youtube_code.blank?
    end
end
