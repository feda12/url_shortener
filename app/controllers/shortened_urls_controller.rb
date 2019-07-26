require 'securerandom'

class ShortenedUrlsController < ApplicationController
  before_action :set_shortened_url, only: [:show, :update, :destroy]

  # GET /shortened_urls
  def index
    @shortened_urls = ShortenedUrl.order(hit_count: :desc).limit(100)

    render json: @shortened_urls,
      each_serializer: TopShortenedUrlSerializer,
      request: request
  end

  # GET /shortened_urls/1
  def show
    if @shortened_url
      @shortened_url.hit_count += 1
      @shortened_url.save
      redirect_to @shortened_url.original_url
    else
      render json: {error: "invalid url"}, status: :bad_request
    end
  end

  # POST /shortened_urls
  def create
    @shortened_url = ShortenedUrl.new(shortened_url_params)
    if @shortened_url.save
      UrlMetadataFetcherJob.perform_later(@shortened_url)
      render json: @shortened_url,
        status: :created,
        location: @shortened_url,
        request: request
    else
      render json: @shortened_url.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shortened_url
      @shortened_url = ShortenedUrl.find_by(slug: params[:slug])
    end

    # Only allow a trusted parameter "white list" through.
    def shortened_url_params
      params.permit(:url)
    end
end
