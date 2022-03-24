RSpec.describe "Users", type: :system do
  describe '新規登録 registrations#create' do
    context '無効な値の場合' do
      it 'エラーメッセージ用の領域が表示されていること' do
        visit new_user_registration_path

        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'foo'
        fill_in 'user_password_confirmation', with: 'bar'
        click_button '新規登録'

        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
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
end