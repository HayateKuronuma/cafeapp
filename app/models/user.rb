class User < ApplicationRecord
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  validates :name, uniqueness: true, presence: true, length: { maximum: 40 }
  validates :email, uniqueness: true, presence: true
  validate :validate_avatar
  validate :password_complexity

  has_one_attached :avatar
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  def favorited_by?(shop_id)
    favorites.exists?(shop_id: shop_id)
  end

  def favorite_id(shop_id)
    favorites.find_by(shop_id: shop_id).id
  end

  def password_complexity
    return if password.blank? || password =~ VALID_PASSWORD_REGEX
    errors.add(:password, 'は英数字混合である必要があります')
  end

  def validate_avatar
    return unless avatar.attached?
    if avatar.blob.byte_size > 1.megabytes
      errors.add(:avatar, 'のサイズは1MBまでです')
    elsif !image?
      errors.add(:avatar, 'が対応している画像データではありません')
    end
  end

  private

  def image?
    %w[image/jpg image/jpeg image/png].include?(avatar.blob.content_type)
  end
end
