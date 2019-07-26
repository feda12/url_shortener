require 'rails_helper'

RSpec.describe UrlMetadataFetcherJob, type: :job do
  let(:job) { UrlMetadataFetcherJob.new }

  describe "perform" do
    it "fetches the url and update the title" do
      shortened_url = ShortenedUrl.create(
        original_url: "http://google.com",
        title: nil,
        slug: SecureRandom.hex(8)
      )

      updated_shortened_url = job.perform(shortened_url)
      expect(updated_shortened_url.title).to eq("Google")
      expect(updated_shortened_url.id).to eq(shortened_url.id)
      expect(updated_shortened_url.slug).to eq(shortened_url.slug)
    end

    it "doesn't change an existing title if fetching fails" do
      shortened_url = ShortenedUrl.create(
        original_url: "http://not-a-valid-url",
        title: SecureRandom.hex(10),
        slug: SecureRandom.hex(8)
      )

      updated_shortened_url = job.perform(shortened_url)
      expect(updated_shortened_url.title).to eq(shortened_url.title)
    end
  end

  describe "fetch_url" do
    it "fetches a valid url" do
      html_file = job.fetch_url("http://google.com")
      # Improvement: test for a temporary file?
      expect(html_file).to_not be_nil()
    end

    it "fails quietly if the url is invalid" do
      expect(job.fetch_url("http:not-valid-url")).to be_nil()
    end

    it "deals with a url nil" do
      expect(job.fetch_url(nil)).to be_nil()
    end
  end

  describe "grab_title" do
    it "returns the title for a fetched url" do
      html_file = job.fetch_url("http://google.com")
      expect(job.grab_title(html_file)).to eq("Google")
    end

    it "returns raw html page title" do
      html_file = "<title>Page</title>"
      expect(job.grab_title(html_file)).to eq("Page")
    end

    it "returns nil if page doesn't have a title" do
      html_file = "<p>No title</p>"
      expect(job.grab_title(html_file)).to be_nil()
    end

    it "returns nil if invalid data passed" do
      expect(job.grab_title(nil)).to be_nil()
    end
  end
end
