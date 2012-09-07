require 'test_helper'

class MembershipControllerTest < ActionController::TestCase
  test "get index" do
    get "index"
    assert_response :success
  end

  test "get user" do
    get "show", {:id => 1801}
    assert_response :success
  end
  
end
