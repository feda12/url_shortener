class TopShortenedUrlSerializer < ShortenedUrlSerializer
  # This is tested through the controller specs
  attributes :url, :original_url, :hit_count, :id
end
