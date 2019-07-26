class ShortenedUrl < ApplicationRecord
  alias_attribute :url, :original_url

  validates :original_url, presence: true
  validates_uniqueness_of :slug

  after_validation(on: :create) do
    self.slug = SecureRandom.hex(5)
  end
end
