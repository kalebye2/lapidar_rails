require 'test_helper'

class AtendimentosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get atendimentos_index_url
    assert_response :success
  end

  test "should get show" do
    get atendimentos_show_url
    assert_response :success
  end

  test "should get new" do
    get atendimentos_new_url
    assert_response :success
  end

  test "should get edit" do
    get atendimentos_edit_url
    assert_response :success
  end

  test "should get create" do
    get atendimentos_create_url
    assert_response :success
  end

  test "should get update" do
    get atendimentos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get atendimentos_destroy_url
    assert_response :success
  end

end
