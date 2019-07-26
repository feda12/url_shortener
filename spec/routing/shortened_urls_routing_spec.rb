require "rails_helper"

RSpec.describe ShortenedUrlsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/").to route_to("shortened_urls#index")
    end

    it "routes to #show" do
      expect(:get => "/slug").to route_to("shortened_urls#show", :id => "slug")
    end


    it "routes to #create" do
      expect(:post => "/").to route_to("shortened_urls#create")
    end
  end
end
