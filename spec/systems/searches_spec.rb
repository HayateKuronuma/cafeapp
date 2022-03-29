require 'rails_helper'


RSpec.describe "Searches", type: :system do
  describe 'topページからの検索機能', js: true do
    before { visit root_path }

    it 'Googlemapが表示されていること' do
      expect(page).to have_css '.gm-style'
    end

    it '検索ボタンが表示されていること' do
      expect(page).to have_content '現在地周辺のワンちゃんと行ける飲食店を検索'
    end

    context '検索ボタンを押したら' do
      before { click_button '現在地周辺のワンちゃんと行ける飲食店を検索' }

      it 'locatingの文字とアニメーションが表示されること' do
        expect(page).to have_content 'Locating...'
        expect(page).to have_selector("img[src$='/running_dog.gif']")
      end
    end
  end
end