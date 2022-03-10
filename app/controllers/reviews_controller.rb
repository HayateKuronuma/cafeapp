class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.new(review_params)
    @shop_id = params[:review][:shop_id]
    @reviews = Review.where(shop_id: @shop_id)
    if @review.save
      flash.now[:notice] = "口コミを投稿しました"
      respond_to do |format|
        format.html { redirect_to shops_path(shop_id: @shop_id) }
        format.js
      end
    else
      render "error"
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    @shop_id = @review.shop_id
    @reviews = Review.where(shop_id: @shop_id)
    if @review.update(review_params)
      flash.now[:notice] = "口コミを編集しました"
      respond_to do |format|
        format.html { redirect_to shops_path(shop_id: @shop_id) }
        format.js
      end
    else
      render "error"
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review_id = @review.id
    @shop_id = @review.shop_id
    @reviews = Review.where(shop_id: @shop_id)
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
end
