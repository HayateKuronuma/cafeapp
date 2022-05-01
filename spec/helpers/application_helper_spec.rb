require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "full_titleメソッドのテスト" do
    context "page_titleがあるとき" do
      it "「page_title - WAN SEARCH」と表示すること" do
        expect(helper.full_title(page_title: "test_title")).to eq "test_title - WAN SEARCH"
      end
    end

    context "page_titleが空白のとき" do
      it "「WAN SEARCH」と表示すること" do
        expect(helper.full_title(page_title: "")).to eq "WAN SEARCH"
      end
    end

    context "page_titleがnilのとき" do
      it "「WAN SEARCH」と表示すること" do
        expect(helper.full_title(page_title: nil)).to eq "WAN SEARCH"
      end
    end
  end
end
