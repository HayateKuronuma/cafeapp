require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it '全て正常な値の時登録できること' do
    expect(user2).to be_valid
  end

  it 'nameが必須であること' do
    user2.name = ''
    expect(user2).to be_invalid
    expect(user2.errors[:name]).to include("を入力してください")
  end

  it 'nameがユニークであること' do
    user2.name = user1.name
    expect(user2).to be_invalid
    expect(user2.errors[:name]).to include("はすでに存在します")
  end

  it 'nameが40文字以内であること' do
    user2.name = 'a' * 41
    expect(user2).to be_invalid
    expect(user2.errors[:name]).to include("は40文字以内で入力してください")
  end

  it 'emailが必須であること' do
    user2.email = ''
    expect(user2).to be_invalid
    expect(user2.errors[:email]).to include("を入力してください")
  end

  it 'emailがユニークであること' do
    user2.email = user1.email
    expect(user2).to be_invalid
    expect(user2.errors[:email]).to include("はすでに存在します")
  end

  it 'emailが有効な形式であること' do
    valid_addresses = %w[user@exmple.com u-se_r@foo.bar.com first.last@foo.jp test.!#$%&'*+/=?^_`{|}~-@example.com]
    valid_addresses.each do |valid_address|
      user2.email = valid_address
      expect(user2).to be_valid
    end
  end

  it '無効な形式のemailは登録失敗すること' do
    invalid_addresses = %w[user@example,com userexamplecom test@example. foo@bar_baz.com]
    invalid_addresses.each do |invalid_address|
      user2.email = invalid_address
      expect(user2).to be_invalid
      expect(user2.errors[:email]).to include("は不正な値です")
    end
  end

  it 'passwordが必須であること' do
    user2.password = user2.password_confirmation = ''
    expect(user2).to be_invalid
    expect(user2.errors[:password]).to include("を入力してください")
  end

  it 'passwordが8文字以上であること' do
    user2.password = user2.password_confirmation = 'a123456'
    expect(user2).to be_invalid
    expect(user2.errors[:password]).to include("は8文字以上で入力してください")
  end

  it 'passwordが英数字混合であること' do
    user2.password = user2.password_confirmation = '123456'
    expect(user2).to be_invalid
    expect(user2.errors[:password]).to include("は英数字混合である必要があります")
  end
end
