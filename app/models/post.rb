class Post < ApplicationRecord
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :title, presence: true
  validates :youtube_url, presence: true
  validates :youtube_url, format: { with: URI.regexp }, if: Proc.new { |p| p.youtube_url.present? }

  def youtube_code
    @youtube_code ||= CGI.parse(URI.parse(youtube_url).query)['v'].first
  end

  def embed_url
    "https://www.youtube.com/embed/#{youtube_code}"
  end
end
