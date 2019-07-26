class ShortenedUrl < ApplicationRecord
  validates :original_url, presence: true

  after_validation(on: :create) do
    self.slug = SecureRandom.hex(10)
  end
end
