require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  setup do
    login
  end

  protected
  def login
    url = URI.parse(root_url)
    url.user = "sync"
    url.password = "sync"
    visit url
  end
end
