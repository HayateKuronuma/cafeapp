class ReviewsController < ApplicationController
  def create
    Review.create(review_params)
    @reviews = Review.where(shop_id: params[:review][:shop_id])
    respond_to do |format|
      format.html { redirect_to shops_path(shop_id: params[:review][:shop_id]) }
      format.js
    end
  end

  private
  def review_params
    params.require(:review).permit(:comment, :title, :shop_id, :user_id)
  end
end
