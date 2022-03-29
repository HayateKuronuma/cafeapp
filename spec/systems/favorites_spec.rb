require 'rails_helper'

RSpec.describe "Favorites", type: :system do
  describe 'shopページからのお気に入り登録と解除', js: true do
    let(:user) { create(:user) }

    before do
      WebMock.allow_net_connect!(:net_http_connect_on_start => true)
      WebMock.stub_request(:get, "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/").
      to_return(
        body: File.read("./spec/fixtures/shop_response.json"),
        status: 200,
      )

      log_in user
    end

    context 'お気に入り登録されていない場合' do
      before { visit shop_path(shop_id: 'J001245046') }

      it '「お気に入りに保存」ボタンが表示されていること' do
        expect(page).to have_content 'お気に入りに保存'
      end

      it '「お気に入りに保存」ボタンを押したらflashが表示されること' do
        click_link 'お気に入りに保存'
        expect(page).to have_selector 'p.alert.alert-notice'
        expect(page).to have_content 'お気に入りに登録しました'
      end

      it '「お気に入りに保存」ボタンを押したら、ボタンが「お気に入り解除」に変わっていること' do
        click_link 'お気に入りに保存'
        expect(page).to have_content 'お気に入り解除'
      end
    end

    context 'お気に入り登録されている場合'do
      let!(:favorite) { create(:favorite, shop_id: 'J001245046', user_id: user.id) }

      before { visit shop_path(shop_id: 'J001245046') }

      it '「お気に入り解除」ボタンが表示されていること' do
        expect(page).to have_content 'お気に入り解除'
      end

      it '「お気に入り解除」ボタンを押したらflashが表示されること' do
        click_link 'お気に入り解除'
        expect(page).to have_selector 'p.alert.alert-error'
        expect(page).to have_content 'お気に入りを削除しました'
      end

      it '「お気に入り解除」ボタンを押したら、ボタンが「お気に入りに保存」に変わっていること' do
        click_link 'お気に入り解除'
        expect(page).to have_content 'お気に入りに保存'
      end
    end
  end

  describe 'お気に入り一覧  favorite#index', js: true do
    let(:user) { create(:user) }
    let!(:favorite1) { create(:favorite, user_id: user.id) }
    let!(:favorite2) { create(:favorite, shop_id: 'J001178490', user_id: user.id) }
    let!(:favorite3) { create(:favorite, shop_id: 'J000245549', user_id: user.id) }

    before do
      WebMock.allow_net_connect!(:net_http_connect_on_start => true)
      WebMock.stub_request(:get, "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/").
      to_return(
        body: File.read("./spec/fixtures/favorites_response.json"),
        status: 200,
      )

      log_in user
      visit favorites_path
    end

    it 'サイドバーのお気に入り一覧に、activeクラスが適応されていること' do
      expect(find('ul').all("a")[1].find('li')[:class]).to include 'active'
    end

    it 'お気に入り一覧が表示されていること' do
      expect(page).to have_content '和食屋 だれかれ'
      expect(page).to have_content '中目黒 ひつじ 東山店'
      expect(page).to have_content 'COSTA LATINA'
    end

    it 'shopカードをクリックしたら、shop詳細ページにアクセスすること' do
      find('#shopname0').click
      expect(current_path).to eq shop_path
      expect(page).to have_content 'COSTA LATINA'
    end

    context 'お気に入りマークをクリックしたら' do
      before do
        page.accept_confirm do
          first('.favorite-delete').find('a').click
        end
      end

      it 'お気に入り解除のflshが表示されること' do
        expect(page).to have_selector 'p.alert.alert-error'
        expect(page).to have_content 'お気に入りを削除しました'
      end

      it '削除したshopが表示されないこと' do
        expect(page).to_not have_content 'COSTA LATINA'
      end
    end
  end
end
