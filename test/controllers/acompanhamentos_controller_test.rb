require 'test_helper'

class AcompanhamentosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get acompanhamentos_index_url
    assert_response :success
  end

  test "should get show" do
    get acompanhamentos_show_url
    assert_response :success
  end

  test "should get new" do
    get acompanhamentos_new_url
    assert_response :success
  end

  test "should get edit" do
    get acompanhamentos_edit_url
    assert_response :success
  end

  test "should get create" do
    get acompanhamentos_create_url
    assert_response :success
  end

  test "should get update" do
    get acompanhamentos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get acompanhamentos_destroy_url
    assert_response :success
  end

end
