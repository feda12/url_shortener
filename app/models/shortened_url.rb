class ShortenedUrl < ApplicationRecord
  alias_attribute :url, :original_url

  validates :original_url, presence: true

  after_save(on: :create) do
    self.slug = id.to_s(36)
  end
end


