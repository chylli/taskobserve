require 'test_helper'

class SignupControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    post :create
    assert_redirected_to :action => "new"
  end

end
