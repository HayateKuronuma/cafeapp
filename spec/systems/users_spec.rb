require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe '新規登録 registrations#create' do
    before { visit new_user_registration_path }

    context '無効な値の場合' do
      it 'エラーメッセージ用の領域が表示されていること' do
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'foo'
        fill_in 'user_password_confirmation', with: 'bar'
        click_button '新規登録'

        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    context '有効な値の場合' do
      before do
        fill_in 'user_name', with: 'newuser'
        fill_in 'user_email', with: 'new-user@example.com'
        fill_in 'user_password', with: 'password123'
        fill_in 'user_password_confirmation', with: 'password123'
        click_button '新規登録'
      end

      it '成功flashメッセージが表示されること' do
        expect(page).to have_selector 'p.alert.alert-notice'
      end

      it 'root_pathが表示されること' do
        expect(current_path).to eq root_path
      end

      it 'headerがログインユーザー向け表示になっていること' do
        expect(page).to have_content 'お気に入り一覧'
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'ログアウト'
      end

      it 'headerにデフォルトavatarが表示されていること' do
        expect(page).to have_selector("img[src$='/default_icon.jpg']")
      end
    end
  end

  describe 'ログイン sessions#new' do
    context '無効な値の場合' do
      it 'エラーflashメッセージが表示される' do
        visit new_user_session_path

        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
        click_button 'ログイン'

        expect(page).to have_selector 'p.alert.alert-error'
      end
    end

    context '有効な値でログインできた場合' do
      let(:user) { create(:user) }

      before do
        log_in user
      end

      it 'root_pathが表示されること' do
        expect(current_path).to eq root_path
      end

      it '成功flashメッセージが表示されること' do
        expect(page).to have_selector 'p.alert.alert-notice'
      end

      it 'headerがログインユーザー向け表示になっていること' do
        expect(page).to have_content 'お気に入り一覧'
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'ログアウト'
      end
    end
  end

  describe 'アカウント情報更新 registrations#edit' do
    let(:user) { create(:user) }

    before do
      log_in user
      visit edit_user_registration_path
    end

    context '無効な値の場合' do
      it 'エラーメッセージ用の領域が表示されていること' do
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'foo'
        fill_in 'user_password_confirmation', with: 'bar'
        fill_in 'user_current_password', with: user.password
        attach_file 'user_avatar', File.join(Rails.root, 'spec/fixtures/images/testimage.gif')
        click_button '更新する'

        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    context '有効な値の場合' do
      before do
        fill_in 'user_name', with: 'edituser'
        fill_in 'user_email', with: 'edit-user@example.com'
        fill_in 'user_password', with: 'newpassword123'
        fill_in 'user_password_confirmation', with: 'newpassword123'
        fill_in 'user_current_password', with: user.password
        attach_file 'user_avatar', File.join(Rails.root, 'spec/fixtures/images/testimage.jpeg')
        click_button '更新する'
      end

      it '成功flashメッセージが表示されること' do
        expect(page).to have_selector 'p.alert.alert-notice'
      end

      it '編集ページが表示されること' do
        expect(current_path).to eq edit_user_registration_path
      end

      it '更新されたavatarがheaderとmainの2箇所に表示されていること' do
        within("header") do
          expect(page).to have_selector("img[src$='testimage.jpeg']")
        end

        within("main") do
          expect(page).to have_selector("img[src$='testimage.jpeg']")
        end
      end
    end
  end
end
