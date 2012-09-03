require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  Name = "inventory"
  Password = "3843054"

  test "login" do
    post "/login", :user_name => Name, :password => Password
    assert_redirected_to root_url
    get "/"
    assert_select "a.navbar-link", Name
  end

  # test "the truth" do
  #   assert true
  # end
end
