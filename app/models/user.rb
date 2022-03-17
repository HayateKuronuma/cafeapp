class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true
  validates :name, uniqueness: true, presence: true

  has_one_attached :avatar
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(shop_id)
    favorites.where(shop_id: shop_id).exists?
  end
end
