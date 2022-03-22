require 'capybara/rspec'

Capybara.register_driver :selenium_chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [options])
end

Capybara.javascript_driver = :selenium_chrome_headless

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :selenium_chrome_headless, options: {
      browser: :remote,
      url: ENV.fetch("SELENIUM_DRIVER_URL"),
      capabilities: :chrome
    }
    Capybara.server_host = 'app'
    Capybara.app_host="http://#{Capybara.server_host}"
  end
end
