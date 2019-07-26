require 'rails_helper'

RSpec.describe ShortenedUrl, type: :model do
  describe "validations" do

  end

  describe "slug" do
    it "generates a new slug on creation" do
      url = ShortenedUrl.create(original_url: "test", slug: nil)
      expect(url.slug).to_not be_nil()
    end

    it "has to be unique" do
      url1 = ShortenedUrl.create(original_url: "A")
      url2 = ShortenedUrl.create(original_url: "B")

      url2.slug = url1.slug
      expect(url2.save).to be(false)
    end
  end
end
