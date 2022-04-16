class ShopsController < ApplicationController
  require 'httpclient'

  def show
    if params[:shop_id].present?
      client = HTTPClient.new
      url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
      query = {
        "key" => Rails.application.credentials.api[:hotpepper_api],
        "id" => params[:shop_id],
        format: "json"
      }
      response = client.get(url, query)
      @results = JSON.parse(response.body)
      @shop = @results['results']['shop'][0]
      @shop_id = @shop["id"]
      @reviews = Review.includes([images_attachments: :blob], user: [:avatar_attachment]).where(shop_id: @shop_id).order(created_at: "DESC")
      @review = Review.new
      if user_signed_in?
        @favorite = current_user.favorites.find_by(shop_id: @shop_id)
      end
    end
  end
end
