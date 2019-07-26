require 'rails_helper'

RSpec.describe UrlMetadataFetcherJob, type: :job do
  describe "perform" do
    it "fetches the url and update the title and meta_updated_at" do

    end

    it "fails quietly if given an invalid object" do

    end

    it "fails quietly if the url does not exist" do

    end
  end

  describe "fetch_url" do
    it "fetches a valid url" do

    end

    it "fails quietly if the url is invalid" do

    end

    it "deals with a url not set" do

    end
  end

  describe "grab_title" do
    it "returns the title for a fetched url" do

    end

    it "returns nil if page doesn't have a title" do

    end

    it "returns nil if invalid data passed" do

    end
  end
end
