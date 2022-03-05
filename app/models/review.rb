class Review < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :comment, presence: true
  validates :user_id, presence: true
  validates :shop_id, presence: true
end
