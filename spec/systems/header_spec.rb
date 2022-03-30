RSpec.describe "HeaderFooterLayouts", type: :system do
  let(:user) { create(:user) }

  describe 'header' do
    context 'ログイン済みの場合' do
      before do
        log_in user
        visit root_path
      end

      it 'ヘッダーロゴをクリックするとrootに遷移すること' do
        find('.header-logo').click
        expect(page.current_path).to eq root_path
      end

      it 'お気に入り一覧をクリックすると/favoritesに遷移すること' do
        click_link 'お気に入り一覧'
        expect(page.current_path).to eq favorites_path
      end

      it 'マイページをクリックすると/users/editに遷移すること' do
        click_link 'マイページ'
        expect(page.current_path).to eq edit_user_registration_path
      end

      it 'ログアウトをクリックすると/users/sign_inに遷移すること' do
        click_link 'ログアウト'
        expect(page.current_path).to eq new_user_session_path
      end
    end

    context '未ログインの場合' do
      before do
        visit root_path
      end

      it 'ヘッダーロゴをクリックするとrootに遷移すること' do
        find('.header-logo').click
        expect(page.current_path).to eq root_path
      end

      it 'ログインをクリックすると/users/sign_inに遷移すること'  do
        click_link 'ログイン'
        expect(page.current_path).to eq new_user_session_path
      end

      it '登録するをクリックすると/users/sign_upに遷移すること' do
        click_link '登録する'
        expect(page.current_path).to eq new_user_registration_path
      end
    end
  end

  describe 'footer' do
    it 'Copyrightを表示すること' do
      visit root_path
      within(".footer") do
        expect(page).to have_content 'Copyright © 2022 WAN SEARCH'
      end
    end
  end
end
