require "test_helper"

class LaudosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get laudos_index_url
    assert_response :success
  end

  test "should get show" do
    get laudos_show_url
    assert_response :success
  end

  test "should get new" do
    get laudos_new_url
    assert_response :success
  end

  test "should get edit" do
    get laudos_edit_url
    assert_response :success
  end
end
