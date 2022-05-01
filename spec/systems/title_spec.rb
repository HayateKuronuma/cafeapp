require 'rails_helper'

RSpec.describe "動的タイトル表示", type: :system do
  describe "非ログイン時の動的なタイトル表示機能" do
    context "topページの時" do
      it "タイトルが 'WAN SEARCH'であること" do
        visit root_path
        expect(page).to have_title 'WAN SEARCH'
      end
    end

    context "users/sign_inのとき" do
      it "タイトルが 'ログイン - WAN SEARCH'であること" do
        visit new_user_session_path
        expect(page).to have_title 'ログイン - WAN SEARCH'
      end
    end

    context "users/sign_inのとき" do
      it "タイトルが 'アカウント登録 - WAN SEARCH'であること" do
        visit new_user_registration_path
        expect(page).to have_title 'アカウント登録 - WAN SEARCH'
      end
    end
  end

  describe "ログイン時の動的なタイトル表示機能" do
    let! (:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "ログイン"
    end

    context "/favoritesのとき" do
      it "タイトルが 'お気に入り一覧 - WAN SEARCH'であること" do
        visit favorites_path
        expect(page).to have_title 'お気に入り一覧 - WAN SEARCH'
      end
    end

    context "/reviewsのとき" do
      it "タイトルが 'マイレビュー一覧 - WAN SEARCH'であること" do
        visit reviews_path
        expect(page).to have_title 'マイレビュー一覧 - WAN SEARCH'
      end
    end

    context "/users/editのとき" do
      it "タイトルが 'アカウント情報 - WAN SEARCH'であること" do
        visit edit_user_registration_path
        expect(page).to have_title 'アカウント情報 - WAN SEARCH'
      end
    end
  end
end
