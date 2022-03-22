require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "full_titleメソッドのテスト" do
    context "page_titleがあるとき" do
      it "「page_title - CAFE APP」と表示すること" do
        expect(helper.full_title(page_title: "test_title")).to eq "test_title - CAFE APP"
      end
    end

    context "page_titleが空白のとき" do
      it "「CAFE APP」と表示すること" do
        expect(helper.full_title(page_title: "")).to eq "CAFE APP"
      end
    end

    context "page_titleがnilのとき" do
      it "「BIGBAG Store」と表示すること" do
        expect(helper.full_title(page_title: nil)).to eq "CAFE APP"
      end
    end
  end
end
