require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  before { WebMock.disable! }

  describe "GET /index" do
    let(:user) { create(:user) }

    it "リクエストが成功すること" do
      sign_in user
      get favorites_path
      expect(response).to have_http_status(200)
    end
  end
end
