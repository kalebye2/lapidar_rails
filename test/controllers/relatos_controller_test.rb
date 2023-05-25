require 'test_helper'

class RelatosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get relatos_index_url
    assert_response :success
  end

  test "should get show" do
    get relatos_show_url
    assert_response :success
  end

  test "should get new" do
    get relatos_new_url
    assert_response :success
  end

  test "should get edit" do
    get relatos_edit_url
    assert_response :success
  end

  test "should get create" do
    get relatos_create_url
    assert_response :success
  end

  test "should get update" do
    get relatos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get relatos_destroy_url
    assert_response :success
  end

end
