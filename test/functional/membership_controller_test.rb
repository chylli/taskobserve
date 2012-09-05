require 'test_helper'

class MembershipControllerTest < ActionController::TestCase
  test "get index" do
    get "index"
    assert_response :success
  end
  # test "the truth" do
  #   assert true
  # end
end
