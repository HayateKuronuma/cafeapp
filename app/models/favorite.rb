class Favorite < ApplicationRecord
  FAVORITE_MAX_NUMBER = 20

  belongs_to :user

  validates :user_id, presence: true
  validates :shop_id, presence: true
  validate :check_number_of_favorites

  def check_number_of_favorites
    if user && user.favorites.size >= FAVORITE_MAX_NUMBER
      errors.add(:favorite, "登録は20件までです")
    end
  end
end
