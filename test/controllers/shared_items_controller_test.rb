require "test_helper"

class SharedItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shared_items_index_url
    assert_response :success
  end
end
