class FavoritesController < ApplicationController
  require 'httpclient'
  before_action :authenticate_user!

  def index
    @favorites = Favorite.where(user_id: current_user.id).order(created_at: "DESC")
    @favorites_shop_id = @favorites.pluck(:shop_id)
    client = HTTPClient.new
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    query = {
      "key" => Rails.application.credentials.api[:hotpepper_api],
      "id" => @favorites_shop_id,
      "format": "json"
    }
    response = client.get(url, query)
    @results = JSON.parse(response.body)
    @shops = @results['results']['shop']
  end

  def create
    Favorite.create(user_id: current_user.id, shop_id: params[:shop_id])
    @shop_id = params[:shop_id]
    @favorite = current_user.favorites.find_by(shop_id: @shop_id)
    flash.now[:notice] = "お気に入りに登録しました"
    respond_to do |format|
      format.html { redirect_to shop_path(shop_id: params[:shop_id]) }
      format.js
    end
  end

  def destroy
    Favorite.find_by(user_id: current_user.id, shop_id: params[:shop_id]).destroy
    @shop_id = params[:shop_id]
    flash.now[:alert] = "お気に入りを削除しました"
    respond_to do |format|
      format.html { redirect_to shop_path(shop_id: params[:shop_id]) }
      format.js
    end
  end
end
