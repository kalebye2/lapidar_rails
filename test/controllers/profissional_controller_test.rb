require 'test_helper'

class ProfissionalControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get profissional_index_url
    assert_response :success
  end

  test "should get show" do
    get profissional_show_url
    assert_response :success
  end

  test "should get new" do
    get profissional_new_url
    assert_response :success
  end

  test "should get edit" do
    get profissional_edit_url
    assert_response :success
  end

  test "should get create" do
    get profissional_create_url
    assert_response :success
  end

  test "should get update" do
    get profissional_update_url
    assert_response :success
  end

  test "should get destroy" do
    get profissional_destroy_url
    assert_response :success
  end

end
