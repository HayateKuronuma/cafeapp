require 'rails_helper'

RSpec.describe "動的タイトル表示", type: :system do
  describe "非ログイン時の動的なタイトル表示機能" do
    context "topページの時" do
      it "タイトルが 'CAFE APP'であること" do
        visit root_path
        expect(page).to have_title 'CAFE APP'
      end
    end

    context "users/sign_inのとき" do
      it "タイトルが 'ログイン - CAFE APP'であること" do
        visit new_user_session_path
        expect(page).to have_title 'ログイン - CAFE APP'
      end
    end

    context "users/sign_inのとき" do
      it "タイトルが 'アカウント登録 - CAFE APP'であること" do
        visit new_user_registration_path
        expect(page).to have_title 'アカウント登録 - CAFE APP'
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
      it "タイトルが 'お気に入り一覧 - CAFE APP'であること" do
        visit favorites_path
        expect(page).to have_title 'お気に入り一覧 - CAFE APP'
      end
    end

    context "/reviewsのとき" do
      it "タイトルが 'マイレビュー一覧 - CAFE APP'であること" do
        visit reviews_path
        expect(page).to have_title 'マイレビュー一覧 - CAFE APP'
      end
    end

    context "/users/editのとき" do
      it "タイトルが 'アカウント情報 - CAFE APP'であること" do
        visit edit_user_registration_path
        expect(page).to have_title 'アカウント情報 - CAFE APP'
      end
    end
  end
end
