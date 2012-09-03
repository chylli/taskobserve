require 'test_helper'

class InventoryControllerTest < ActionController::TestCase

  test "show custom fields" do
    get "item", {:id => 320808}
    assert_response :success
    assert_select "td", "Price"
  end


  # test "the truth" do
  #   assert true
  # end
end
