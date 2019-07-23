require "rails_helper"

RSpec.describe ShortenedUrlsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/shortened_urls").to route_to("shortened_urls#index")
    end

    it "routes to #show" do
      expect(:get => "/shortened_urls/1").to route_to("shortened_urls#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/shortened_urls").to route_to("shortened_urls#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shortened_urls/1").to route_to("shortened_urls#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shortened_urls/1").to route_to("shortened_urls#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shortened_urls/1").to route_to("shortened_urls#destroy", :id => "1")
    end
  end
end
