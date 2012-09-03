require 'test_helper'

class LogonControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    post :create
    assert_redirected_to login_url
  end

  test "should get destroy" do
    delete :destroy
    assert_redirected_to root_url
  end

end
