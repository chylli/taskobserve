require 'test_helper'

class ActivityControllerTest < ActionController::TestCase
  test "get activity index" do
    get "index"
    assert_response :success
  end
  
  test "get user activity" do
    get "show", {:type => 'user', :id => 1801}
    assert_response :success
  end

  test "get task activity" do
    get "show", {:type => 'task', :id => 320808}
    assert_response :success
  end

end
