require "test_helper"

class AcompanhamentoTiposControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get acompanhamento_tipos_index_url
    assert_response :success
  end

  test "should get show" do
    get acompanhamento_tipos_show_url
    assert_response :success
  end

  test "should get new" do
    get acompanhamento_tipos_new_url
    assert_response :success
  end

  test "should get create" do
    get acompanhamento_tipos_create_url
    assert_response :success
  end

  test "should get edit" do
    get acompanhamento_tipos_edit_url
    assert_response :success
  end

  test "should get update" do
    get acompanhamento_tipos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get acompanhamento_tipos_destroy_url
    assert_response :success
  end
end
