require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { create(:review, rate: 4.5) }
  let(:review2) { create(:review, rate: 2.5) }

  it '全て有効な値の場合登録できること' do
    expect(review).to be_valid
  end

  it 'titleが必須であること' do
    review.title = ''
    expect(review).to be_invalid
    expect(review.errors[:title]).to include("を入力してください")
  end

  it 'commentが必須であること' do
    review.comment = ''
    expect(review).to be_invalid
    expect(review.errors[:comment]).to include("を入力してください")
  end

  it 'user_idが必須であること' do
    review.user_id = ''
    expect(review).to be_invalid
    expect(review.errors[:user_id]).to include("を入力してください")
  end

  it 'shop_idが必須であること' do
    review.shop_id = ''
    expect(review).to be_invalid
    expect(review.errors[:shop_id]).to include("を入力してください")
  end

  it 'shop_nameが必須であること' do
    review.shop_name = ''
    expect(review).to be_invalid
    expect(review.errors[:shop_name]).to include("を入力してください")
  end

  it 'rateが必須であること' do
    review.rate = ''
    expect(review).to be_invalid
    expect(review.errors[:rate]).to include("を入力してください")
  end

  it 'rateが5以下であること' do
    review.rate = 6
    expect(review).to be_invalid
    expect(review.errors[:rate]).to include("は5以下の値にしてください")
  end

  it 'rateが1以上であること' do
    review.rate = 0
    expect(review).to be_invalid
    expect(review.errors[:rate]).to include("は1以上の値にしてください")
  end

  describe "reviews_averageのテスト" do
    let(:review3) { create(:review, rate: 3) }

    it "rateの平均を小数点以下1桁の四捨五入で取得できること" do
      review
      review2
      review3
      expect(Review.reviews_average(review.shop_id)).to eq 3.3
    end
  end

  describe "reviews_countのテスト" do
    it "レビューの件数を取得できること" do
      review
      review2
      expect(Review.reviews_count(review.shop_id)).to eq 2
    end
  end

  describe "represent_reviewのテスト" do
    it "最新reviewのタイトルとコメントを配列で取得できること" do
      review
      review2
      expect(Review.represent_review(review.shop_id)).to match_array([review2.title, review2.comment])
    end
  end
end
