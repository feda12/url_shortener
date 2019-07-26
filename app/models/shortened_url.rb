class ShortenedUrl < ApplicationRecord
  validates :original_url, presence: true
  validates_uniqueness_of :slug

  after_validation(on: :create) do
    self.slug = SecureRandom.hex(5)
  end
end
