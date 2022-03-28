require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  before { WebMock.disable! }

  describe "GET /favorites favorites#index" do
    let(:user) { create(:user) }

    context '未ログインの場合' do
      it 'ログイン画面へリダイレクトすること' do
        get favorites_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログイン済みの場合' do
      it "リクエストが成功すること" do
        sign_in user
        get favorites_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /favorites favorites#create" do
    let(:user) { create(:user) }
    let(:favorite_params) { { shop_id: "J001245046", user_id: user.id } }

    context '未ログインの場合' do
      it "お気に入り登録が失敗すること" do
        expect{
          post favorites_path, params: favorite_params, xhr: true
        }.to_not change(Favorite, :count)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in user }

      it 'お気に入り登録できること' do
        expect{
          post favorites_path, params: favorite_params, xhr: true
        }.to change(Favorite, :count).by(1)
      end

      it 'リクエストが成功すること' do
        post favorites_path, params: favorite_params, xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /favorites/:id favorites#destroy' do
    let(:user) { create(:user) }
    let!(:favorite) { create(:favorite) }

    context '未ログインの場合' do
      it 'ログイン画面へリダイレクトすること' do
        delete favorite_path(favorite)
        expect(response).to redirect_to new_user_session_path
      end

      it 'favoriteが削除できないこと' do
        expect {
          delete favorite_path(favorite)
        }.to_not change(Favorite, :count)
      end
    end

    context 'ログイン済みの場合' do
      it 'favoriteがAjaxで削除できること' do
        sign_in user
        expect {
          delete favorite_path(favorite), xhr: true
        }.to change(Favorite, :count).by (-1)
      end
    end
  end
end
