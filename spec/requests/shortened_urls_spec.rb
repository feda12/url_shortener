require 'rails_helper'

RSpec.describe "ShortenedUrls", type: :request do
  describe "GET /shortened_urls" do
    it "works! (now write some real specs)" do
      get shortened_urls_path
      expect(response).to have_http_status(200)
    end
  end
end
