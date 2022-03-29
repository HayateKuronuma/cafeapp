module SigninSupport
  module Request
    def signed_in?
      !session.nil?
    end
  end

  module System
    def log_in(user)
      visit new_user_session_path

      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "ログイン"
    end

    def guest_log_in
      visit new_user_session_path
      click_link "ゲストログイン"
    end
  end
end

RSpec.configure do |config|
  config.include SigninSupport::Request, type: :request
  config.include SigninSupport::System, type: :system
end
