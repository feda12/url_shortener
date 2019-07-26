require 'open-uri'
require 'nokogiri'

class UrlMetadataFetcherJob < ApplicationJob
  queue_as :default

  def perform(shortened_url)
    html = fetch_url(shortened_url.original_url)
    title = grab_title(html)

    if title
      shortened_url.title = title
      shortened_url.save
    end

    shortened_url
  end

  # From:
  # https://www.rubyguides.com/2012/01/parsing-html-in-ruby/
  def fetch_url(url)
    begin
      open(url)
    rescue => e
      # Add a log message to notify of failure to connect to url
      nil
    end
  end

  def grab_title(html)
    begin
      parsed_html = Nokogiri::HTML.parse(html)
      parsed_html.try(:title)
    rescue => e
      # Add a log message to notify of failure to get title out of html
      nil
    end
  end
end
