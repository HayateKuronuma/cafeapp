require 'rails_helper'

RSpec.describe "Shops", type: :request do
  describe "GET /show" do
    it "リクエストが成功すること" do
      get shop_path
      expect(response).to have_http_status(200)
    end
  end

end
