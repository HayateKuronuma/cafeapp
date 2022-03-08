class ReviewsController < ApplicationController
  before_action :check_login, only: [:create,:destroy]

  def create
    @review = Review.new(review_params)
    @reviews = Review.where(shop_id: params[:review][:shop_id])
    if @review.save
      flash.now[:notice] = "口コミを投稿しました"
      respond_to do |format|
        format.html { redirect_to shops_path(shop_id: params[:review][:shop_id]) }
        format.js
      end
    else
      render "error"
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review_id = @review.id
    @review.destroy
    flash.now[:alert] = "投稿を削除しました"
    respond_to do |format|
      format.html { redirect_to shops_path(shop_id: @review.shop_id) }
      format.js
    end
  end

  private
  def review_params
    params.require(:review).permit(:comment, :title, :shop_id, :user_id, :rate)
  end

  def check_login
    redirect_to :root if current_user == nil
  end
end
