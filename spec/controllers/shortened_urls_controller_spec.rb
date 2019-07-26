require 'rails_helper'
require 'securerandom'

RSpec.describe ShortenedUrlsController, type: :controller do
  describe "GET #index" do
    it "returns the top 100" do
      saved_urls = []
      for i in 1..100 do
        saved_urls.push(ShortenedUrl.create!(
          slug: SecureRandom.hex,
          original_url: SecureRandom.hex,
          hit_count: i
        ))
      end

      get :index
      expect(response).to be_successful
      top_100 = JSON.parse(response.body)

      expect(top_100.first["hit_count"]).to eq(100)
      expect(top_100.last["hit_count"]).to eq(1)
      expect(top_100.first["id"]).to eq(saved_urls.last.id)
      expect(top_100.last["id"]).to eq(saved_urls.first.id)
    end
  end

  describe "GET #show" do
    it "redirects to the right URL and increment the hit count" do
      random_hit_count = rand(1..20)
      random_slug = SecureRandom.hex
      shortened_url = ShortenedUrl.create!(
        original_url: "http://google.com",
        hit_count: random_hit_count,
        slug: random_slug)

      get :show, params: {id: shortened_url.slug}
      expect(response).to redirect_to("http://google.com")

      shortened_url.reload
      expect(shortened_url.hit_count).to eq(random_hit_count + 1)
    end

    it "returns an error when the slug is invalid" do
      random_slug = SecureRandom.hex
      get :show, params: {id: random_slug}
      expect(response).to have_http_status(:bad_request)
    end

    it "redirects to an invalid url and still update the count" do
      random_hit_count = rand(1..20)
      random_slug = SecureRandom.hex
      shortened_url = ShortenedUrl.create!(
        original_url: "not a url",
        hit_count: random_hit_count,
        slug: random_slug)

      get :show, params: {id: shortened_url.slug}
      shortened_url.reload
      expect(shortened_url.hit_count).to eq(random_hit_count + 1)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "renders a JSON response with the new shortened_url" do
        post :create, params: {shortened_url: {original_url: "http://google.com"}}
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(shortened_url_url(ShortenedUrl.last))
      end

      it "kicks up a background job to fetch title" do
        expect(UrlMetadataFetcherJob).to receive(:perform_later).once
        post :create, params: {shortened_url: {original_url: "http://google.com"}}
      end
    end

    context "with invalid params" do
      it "returns an error if no params given" do
        post :create, params: {}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end

      it "does not allow a user to set its own slug" do
        post :create, params: {shortened_url: {slug: "12932"}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
