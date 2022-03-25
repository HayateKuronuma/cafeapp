require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }

    it "リクエストが成功すること" do
      sign_in user
      get reviews_path
      expect(response).to have_http_status(200)
    end
  end
end
