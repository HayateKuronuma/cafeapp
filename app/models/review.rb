class Review < ApplicationRecord
  RATE_AVERAGE_ROUNDED_OUT_DIGIT = 1
  GET_LATEST_REVIEW_MAX_NUMBER = 1

  belongs_to :user
  has_many_attached :images
  validates :images, attached_file_number: { maximum: 4 }, attached_file_size: { maximum: 1.megabytes }, attached_file_type: { pattern: /^image\// }
  validates :title, presence: true
  validates :comment, presence: true
  validates :user_id, presence: true
  validates :shop_id, presence: true
  validates :shop_name, presence: true
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true

  def self.reviews_average(shop_id)
    where(shop_id: shop_id).average(:rate).to_f.round(RATE_AVERAGE_ROUNDED_OUT_DIGIT)
  end

  def self.reviews_count(shop_id)
    where(shop_id: shop_id).size
  end

  def self.represent_review(shop_id)
    where(shop_id: shop_id).order(created_at: "DESC").limit(GET_LATEST_REVIEW_MAX_NUMBER).pluck(:title, :comment).flatten
  end
end
