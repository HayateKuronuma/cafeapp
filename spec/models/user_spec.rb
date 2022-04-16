require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it '全て正常な値の時user登録できること' do
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

  it 'avatarの拡張子が対応していない時登録できないこと' do
    user2.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/testimage.gif'))
    expect(user2).to be_invalid
    expect(user2.errors[:avatar]).to include("が対応している画像データではありません")
  end

  it 'avatarのファイルサイズが1Mより大きい時、登録できないこと' do
    user2.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/test2m.jpg'))
    expect(user2).to be_invalid
    expect(user2.errors[:avatar]).to include("のサイズは1MBまでです")
  end

  it 'avatarが対応ファイルの時登録できること' do
    user2.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/testimage.jpeg'))
    expect(user2).to be_valid
  end

  describe 'favorited_by?メソッドのテスト' do
    it 'お気に入り登録されていない場合、falseを返すこと' do
      expect(user1.favorited_by?("J001245046")).to eq false
    end

    context 'お気に入り登録されている場合' do
      let(:favorite) { create(:favorite, user_id: user1.id) }

      it 'trueを返すこと' do
        expect(user1.favorited_by?(favorite.shop_id)).to eq true
      end
    end
  end

  describe 'favorite_idメソッドのテスト' do
    let(:favorite) { create(:favorite, user_id: user1.id) }

    it '引数に渡したshop_idを持つfavoriteのidを取得すること' do
      expect(user1.favorite_id(favorite.shop_id)).to eq favorite.id
    end
  end

  describe 'self.guestメソッドのテスト' do
    context 'ゲストユーザー未作成の場合' do
      it 'メソッドを使用したらゲストユーザー登録ができること' do
        user = User.guest
        expect(user).to be_valid
      end

      it 'ゲストユーザの名前とアドレスが設定通りになっていること' do
        user = User.guest
        expect(user.name).to eq 'ゲストユーザー'
        expect(user.email).to eq 'guest@example.com'
      end
    end

    context '既にゲストユーザー作成済みの場合' do
      let!(:guest_user) { create(:user, name: 'ゲストユーザー', email: 'guest@example.com') }
      it 'ゲストユーザ情報を取得すること' do
        expect(User.guest).to eq guest_user
      end
    end
  end
end
