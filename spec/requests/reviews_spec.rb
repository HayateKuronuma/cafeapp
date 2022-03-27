require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "Reviews", type: :request do
  before do
    WebMock.stub_request(:get, "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/").
    to_return(
      body: File.read("./spec/fixtures/response.json"),
      status: 200,
    )
  end

  describe "GET /reviews reviews#index" do
    let(:user) { create(:user) }

    context '未ログインの場合' do
      it 'ログイン画面へリダイレクトすること' do
        get reviews_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログイン済みの場合' do
      it "リクエストが成功すること" do
        sign_in user
        get reviews_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /reviews reviews#create' do
    let(:user) { create(:user) }
    let(:review_params) { { review: { title: 'TestTitle',
                                      comment: 'TestComment',
                                      rate: 5,
                                      shop_name: 'TestShop1',
                                      shop_id: 'TestShop1',
                                      user_id: user.id } } }

    context '未ログインの場合' do
      it "投稿が失敗すること" do
        expect{
          post reviews_path, params: review_params, xhr: true
        }.to_not change(Review, :count)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in user }

      it '投稿できること' do
        expect{
          post reviews_path, params: review_params, xhr: true
        }.to change(Review, :count).by(1)
      end

      it 'リクエストが成功すること' do
        post reviews_path, params: review_params, xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH /reviews/:id reviews#update' do
    let(:user) { create(:user) }
    let!(:review) { create(:review) }

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        patch review_path(review), params: { review: { title: 'ChangeTile',
                                                       comment: 'ChangeComment' } }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログイン済みの場合' do
      before do
        sign_in user
        get shop_path(shop_id: 'J001245046')
      end

      context 'かつ無効な値の場合' do
        before do
          patch review_path(review), params: { review: { title: '',
                                                         comment: '' } }, xhr: true
        end

        it 'Ajaxで更新できないこと' do
          review.reload
          expect(review.title).to_not eq ''
          expect(review.comment).to_not eq ''
        end

        it '更新失敗後、レスポンスにエラー文が含まれていること' do
          expect(response.body).to include 'タイトルを入力してください'
        end
      end

      context 'かつ有効な値の場合' do
        before do
          @title = 'ChangeTile'
          @comment = 'ChangeComment'
          @rate = 3
          patch review_path(review), params: { review: { title: @title,
                                                         comment: @comment,
                                                         rate: @rate } }, xhr: true
        end

        it 'Ajaxで更新でるきこと' do
          review.reload
          expect(review.title).to eq @title
          expect(review.comment).to eq @comment
          expect(review.rate).to eq @rate
        end

        it 'リクエストが成功すること' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'DELETE /reviews/:id reviews#destroy' do
    let(:user) { create(:user) }
    let!(:review) { create(:review) }

    context '未ログインの場合' do
      it 'ログイン画面へリダイレクトすること' do
        delete review_path(review)
        expect(response).to redirect_to new_user_session_path
      end

      it '削除できないこと' do
        expect {
          delete review_path(review)
        }.to_not change(Review, :count)
      end
    end

    context 'ログイン済みの場合' do
      it 'Ajaxで削除できること' do
        sign_in user
        expect {
          delete review_path(review), xhr: true
        }.to change(Review, :count).by (-1)
      end
    end
  end
end
