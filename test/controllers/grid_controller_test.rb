require 'test_helper'

class GridControllerTest < ActionDispatch::IntegrationTest
  test "should get view" do
    get grid_view_url
    assert_response :success
  end

  test "should get generate" do
    get grid_generate_url
    assert_response :success
  end

end
