require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "Reviews", type: :system do
  before do
    WebMock.allow_net_connect!(:net_http_connect_on_start => true)
    WebMock.stub_request(:get, "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/").
    to_return(
      body: File.read("./spec/fixtures/shop_response.json"),
      status: 200,
    )
  end

  describe '最新口コミ reviews#current_index' do
    context '最新口コミがある場合', js: true do
      let(:user) { create(:user) }
      let!(:review) { create(:review, user_id: user.id) }

      it '口コミが表示されていること' do
        visit current_reviews_reviews_path
        expect(page).to have_content user.name
        expect(page).to have_content review.shop_name
        expect(page).to have_content review.title
        expect(page).to have_content review.comment
      end
    end

    context '最新口コミがない場合' do
      it '現在クチコミはありませんと表示されること' do
        visit current_reviews_reviews_path
        expect(page).to have_content '現在クチコミはありません'
      end
    end
  end

  describe '新規投稿 review#create' do
    let(:user) { create(:user) }

    before do
      log_in user
      visit shop_path(shop_id: 'J001245046')
    end

    context '無効な値の場合', js: true do
      it 'エラーメッセージ用の領域が表示されていること' do
        within('.shop-review-frame') do
          click_button '口コミを投稿する'
        end
        fill_in 'review[title]', with: ''
        fill_in 'review[comment]', with: ''
        click_button '投稿する'

        expect(page).to have_selector 'div#error_explanation'
      end
    end

    context '有効な値の場合', js: true do
      before do
        @title = 'TestTitle'
        @comment = 'TestComment'
        within('.shop-review-frame') do
          click_button '口コミを投稿する'
        end
        fill_in 'review[title]', with: @title
        fill_in 'review[comment]', with: @comment
        find('#reviewModal').find('.star3').click
        attach_file "review[images][]", "#{Rails.root}/spec/fixtures/images/testimage.jpeg"
        click_button '投稿する'
      end

      it '成功flashが表示されていること' do
        expect(page).to have_selector 'p.alert.alert-notice'
      end

      it '投稿ユーザー名、投稿内容、ユーザーアイコンが表示されていること' do
        expect(page).to have_content @title
        expect(page).to have_content @comment
        expect(page).to have_content user.name
        expect(page).to have_selector("img[src$='testimage.jpeg']")
        within('.shop-review-frame') do
          expect(all("img[src$='star-on.png']").count).to eq 2
          expect(all("img[src$='star-half.png']").count).to eq 1
          expect(page).to have_selector("img[src$='/default_icon.jpg']")
        end
      end

      it 'shopページを表示していること' do
        expect(current_path).to eq shop_path
      end
    end
  end

  describe '編集 review#edit, update' do
    let(:user) { create(:user) }
    let!(:review) { create(:review, user_id: user.id) }

    before { log_in user }

    context 'shop_pathからの場合', js: true do
      before { visit shop_path(shop_id: 'J001245046') }

      context 'かつ無効な値の場合' do
        it 'エラーメッセージ用の領域が表示されていること' do
          find('.edit-delete-btn').find('span').click
          fill_in 'review[title]', with: ''
          fill_in 'review[comment]', with: ''
          click_button '更新する'

          expect(page).to have_selector 'div#error_explanation'
        end
      end

      context 'かつ有効な値の場合' do
        before do
          @edit_title = 'EditTitle'
          @edit_comment = 'EditComment'
          find('.edit-delete-btn').find('span').click
          find("#reviewEditModal#{review.id}").find('.star5').click
          fill_in 'review[title]', with: @edit_title
          fill_in 'review[comment]', with: @edit_comment
          attach_file "review[images][]", ["#{Rails.root}/spec/fixtures/images/testimage.jpeg", "#{Rails.root}/spec/fixtures/images/testimage2.jpeg"]
          click_button '更新する'
        end

        it '成功flashメッセージが表示されること' do
          expect(page).to have_selector 'p.alert.alert-notice'
        end

        it 'shopページを表示していること' do
          expect(current_path).to eq shop_path
        end

        it '更新した内容が表示されていること' do
          expect(page).to have_content @edit_title
          expect(page).to have_content @edit_comment
          expect(page).to have_selector("img[src$='testimage.jpeg']")
          expect(page).to have_selector("img[src$='testimage2.jpeg']")
          within("#rv-wrapper-#{review.id}") do
            expect(all("img[src$='star-on.png']").count).to eq 4
            expect(all("img[src$='star-half.png']").count).to eq 1
          end
        end
      end
    end

    context 'マイレビュー一覧からの場合', js: true do
      before { visit reviews_path }

      context 'かつ無効な値の場合' do
        it 'エラーメッセージ用の領域が表示されていること' do
          find('.edit-delete-btn').find('span').click
          fill_in 'review[title]', with: ''
          fill_in 'review[comment]', with: ''
          click_button '更新する'

          expect(page).to have_selector 'div#error_explanation'
        end
      end

      context 'かつ有効な値の場合' do
        before do
          @edit_title = 'EditTitle'
          @edit_comment = 'EditComment'
          find('.edit-delete-btn').find('span').click
          find("#reviewEditModal#{review.id}").find('.star5').click
          fill_in 'review[title]', with: @edit_title
          fill_in 'review[comment]', with: @edit_comment
          attach_file "review[images][]", ["#{Rails.root}/spec/fixtures/images/testimage.jpeg", "#{Rails.root}/spec/fixtures/images/testimage2.jpeg"]
          click_button '更新する'
        end

        it '成功flashメッセージが表示されること' do
          expect(page).to have_selector 'p.alert.alert-notice'
        end

        it 'マイレビュー一覧ページが表示されていること' do
          expect(current_path).to eq reviews_path
        end

        it '更新した内容が表示されていること' do
          expect(page).to have_content @edit_title
          expect(page).to have_content @edit_comment
          expect(page).to have_selector("img[src$='testimage.jpeg']")
          expect(page).to have_selector("img[src$='testimage2.jpeg']")
          within("#rv-wrapper-#{review.id}") do
            expect(all("img[src$='star-on.png']").count).to eq 4
            expect(all("img[src$='star-half.png']").count).to eq 1
          end
        end
      end
    end
  end

  describe '削除 review#destroy' do
    let(:user) { create(:user) }
    let!(:review) { create(:review, user_id: user.id) }

    before { log_in user }

    context 'shop_pathからの場合', js: true do
      before { visit shop_path(shop_id: 'J001245046') }

      context 'confirmダイアログでokを押したら' do
        before do
          page.accept_confirm do
            find('.review-delete-btn').click
          end
        end

        it '削除成功flashが表示されること' do
          expect(page).to have_selector 'p.alert.alert-notice'
        end

        it '投稿が画面から消えていること' do
          expect(page).to_not have_content review.title
          expect(page).to_not have_content review.comment
          expect(page).to_not have_content user.name
          within('.shop-review-frame') do
            expect(page).to_not have_selector("img[src$='/default_icon.jpg']")
          end
        end
      end

      context 'confirmダイアログでキャンセルを押したら' do
        it '削除されず、投稿が残っていること' do
          page.dismiss_confirm do
            find('.review-delete-btn').click
          end

          expect(page).to have_content review.title
          expect(page).to have_content review.comment
          expect(page).to have_content user.name
          within('.shop-review-frame') do
            expect(page).to have_selector("img[src$='/default_icon.jpg']")
          end
        end
      end
    end

    context 'マイレビュー一覧からの場合', js: true do
      before { visit reviews_path }

      context 'confirmダイアログでokを押したら' do
        before do
          page.accept_confirm do
            find('.review-delete-btn').click
          end
        end

        it '削除成功flashが表示されること' do
          expect(page).to have_selector 'p.alert.alert-notice'
        end

        it '投稿が画面から消えていること' do
          expect(page).to_not have_content review.title
          expect(page).to_not have_content review.comment
          expect(page).to_not have_content review.shop_name
        end
      end

      context 'confirmダイアログでキャンセルを押したら' do
        it '削除されず、投稿が残っていること' do
          page.dismiss_confirm do
            find('.review-delete-btn').click
          end

          expect(page).to have_content review.title
          expect(page).to have_content review.comment
          expect(page).to have_content review.shop_name
        end
      end
    end
  end

  describe 'マイレビュー一覧 review#index' do
    let(:user) { create(:user) }
    let!(:review1) { create(:review, user_id: user.id) }
    let!(:review2) { create(:review, user_id: user.id) }
    let!(:review3) { create(:review, user_id: user.id) }

    before do
      log_in user
      visit reviews_path
    end

    it 'サイドバーのマイレビュー一覧に、activeクラスが適応されていること' do
      within('.side-bar-wrapper') do
        expect(find('ul').all("a")[2].find('li')[:class]).to include 'active'
      end
    end

    it 'レビュー一覧が表示されていること' do
      expect(page).to have_content review1.rate
      expect(page).to have_content review1.title
      expect(page).to have_content review1.comment
      expect(page).to have_content review1.shop_name
      expect(page).to have_content review2.rate
      expect(page).to have_content review2.title
      expect(page).to have_content review2.comment
      expect(page).to have_content review2.shop_name
      expect(page).to have_content review3.rate
      expect(page).to have_content review3.title
      expect(page).to have_content review3.comment
      expect(page).to have_content review3.shop_name
    end
  end
end