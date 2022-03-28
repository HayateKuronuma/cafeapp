require 'rails_helper'

RSpec.describe Favorite, type: :model do

  describe "check_number_of_favoritesのテスト" do
    let(:favorite) { create(:favorite) }

    it '全て有効な値の場合favorite登録できること' do
      expect(favorite).to be_valid
    end

    it 'shop_idが必須であること' do
      favorite.shop_id = ''
      expect(favorite).to be_invalid
      expect(favorite.errors[:shop_id]).to include("を入力してください")
    end

    it 'user_idが必須であること' do
      favorite.user_id = ''
      expect(favorite).to be_invalid
      expect(favorite.errors[:user_id]).to include("を入力してください")
    end
  end

  describe "check_number_of_favoritesのテスト" do
    let(:user) { create(:user) }
    let!(:favorites) { create_list(:favorite, 20, user_id: user.id) }
    let(:favorite21) { build(:favorite, user_id: user.id) }

    it '既にお気に入りが20件ある場合、それ以上登録できないこと' do
      expect(favorite21).to be_invalid
      expect(favorite21.errors[:favorite]).to include("登録は20件までです")
    end
  end
end
