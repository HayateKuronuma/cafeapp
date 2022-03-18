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
    @favorite = Favorite.new(user_id: current_user.id, shop_id: params[:shop_id])
    @shop_id = params[:shop_id]
    if @favorite.save
      flash.now[:notice] = "お気に入りに登録しました"
      respond_to do |format|
        format.html { redirect_to shop_path(shop_id: params[:shop_id]) }
        format.js
      end
    else
      render "favorite_error"
    end
  end

  def destroy
    path = Rails.application.routes.recognize_path(request.referer)
    Favorite.find_by(id: params[:id]).destroy
    @shop_id = params[:shop_id]
    if path[:controller] == "shops" && path[:action] == "show"
      flash.now[:alert] = "お気に入りを削除しました"
      respond_to do |format|
        format.html { redirect_to shop_path(shop_id: params[:shop_id]) }
        format.js
      end
    elsif path[:controller] == "favorites" && path[:action] == "index"
      redirect_to favorites_path, alert: "お気に入りを削除しました"
    end
  end
end
