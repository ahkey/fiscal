require "test_helper"
require "app"

class AppTest < MiniTest::Test
  include Rack::Test::Methods
  def app
    App
  end

  def test_retrieve_issues
    get '/issues'
    assert_equal last_response.body, "Issue"
  end
end
