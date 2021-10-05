require 'test_helper'

class CatsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cats_new_url
    assert_response :success
  end

end
