require 'test_helper'

class FamiliesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get families_new_url
    assert_response :success
  end

end
