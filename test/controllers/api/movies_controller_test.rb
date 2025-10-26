require "test_helper"

class Api::MoviesControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get api_movies_search_url
    assert_response :success
  end
end
