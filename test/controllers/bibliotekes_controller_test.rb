require "test_helper"

class BibliotekesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bibliotekes_index_url
    assert_response :success
  end
end
