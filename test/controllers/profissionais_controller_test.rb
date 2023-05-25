require 'test_helper'

class ProfissionaisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get profissionais_index_url
    assert_response :success
  end

  test "should get show" do
    get profissionais_show_url
    assert_response :success
  end

  test "should get new" do
    get profissionais_new_url
    assert_response :success
  end

  test "should get edit" do
    get profissionais_edit_url
    assert_response :success
  end

  test "should get create" do
    get profissionais_create_url
    assert_response :success
  end

  test "should get update" do
    get profissionais_update_url
    assert_response :success
  end

  test "should get destroy" do
    get profissionais_destroy_url
    assert_response :success
  end

end
