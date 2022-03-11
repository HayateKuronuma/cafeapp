class Review < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :comment, presence: true
  validates :user_id, presence: true
  validates :shop_id, presence: true
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
end
