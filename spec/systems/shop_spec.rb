require 'rails_helper'

RSpec.describe "Shop", type: :system do
  before do
    WebMock.allow_net_connect!(:net_http_connect_on_start => true)
    WebMock.stub_request(:get, "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/").
    to_return(
      body: File.read("./spec/fixtures/shop_response.json"),
      status: 200,
    )
  end

  describe 'shopページの表示', js: true do
    before { visit shop_path(shop_id: 'J001245046') }

    it 'shop情報が表示されていること' do
      expect(page).to have_content '和食屋 だれかれ'
      expect(page).to have_content '最寄駅'
      expect(page).to have_content '池尻大橋'
      expect(page).to have_content 'ジャンル'
      expect(page).to have_content '居酒屋'
      expect(page).to have_content '定休日'
      expect(page).to have_content '日'
      expect(page).to have_content '東京都目黒区東山２-４-１６'
    end

    it 'Googlemapが表示されていること' do
      expect(page).to have_css '.gm-style'
      within('#gmimap0') do
        expect(page).to have_css 'area'
      end
    end
  end
end
