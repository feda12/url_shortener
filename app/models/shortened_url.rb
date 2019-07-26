class ShortenedUrl < ApplicationRecord
  validates :original_url, presence: true
end
