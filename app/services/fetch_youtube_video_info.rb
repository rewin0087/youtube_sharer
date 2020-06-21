require 'open-uri'

class FetchYoutubeVideoInfo

  def initialize(url)
    @doc = Nokogiri::HTML(URI.open(url))
  end

  def call
    {
      title: doc.css('title').text,
      description: doc.css('#content #eow-description').text
    }
  end

  private

    attr_reader :doc
end