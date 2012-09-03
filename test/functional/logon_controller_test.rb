require 'test_helper'

class LogonControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "login with null value" do
    post :create
    assert_redirected_to login_url
  end

  test "login" do
    post :create, :user_name => "inventory", :password => "3843054"
    assert_redirected_to root_url
  end



  test "should logout" do
    delete :destroy
    assert_redirected_to root_url
  end

end
