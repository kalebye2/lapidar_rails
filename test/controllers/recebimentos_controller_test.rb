require "test_helper"

class RecebimentosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recebimentos_index_url
    assert_response :success
  end

  test "should get show" do
    get recebimentos_show_url
    assert_response :success
  end

  test "should get new" do
    get recebimentos_new_url
    assert_response :success
  end

  test "should get create" do
    get recebimentos_create_url
    assert_response :success
  end

  test "should get update" do
    get recebimentos_update_url
    assert_response :success
  end

  test "should get delete" do
    get recebimentos_delete_url
    assert_response :success
  end
end
