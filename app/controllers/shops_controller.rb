class ShopsController < ApplicationController
  require 'httpclient'

  def show
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
    @reviews = Review.where(shop_id: @shop_id).order(created_at: "DESC")
    @review = Review.new
    @favorite = current_user.favorites.find_by(shop_id: @shop_id)
  end
end
