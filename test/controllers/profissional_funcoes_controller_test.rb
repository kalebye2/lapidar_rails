require "test_helper"

class ProfissionalFuncoesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get profissional_funcoes_index_url
    assert_response :success
  end

  test "should get show" do
    get profissional_funcoes_show_url
    assert_response :success
  end

  test "should get new" do
    get profissional_funcoes_new_url
    assert_response :success
  end

  test "should get create" do
    get profissional_funcoes_create_url
    assert_response :success
  end

  test "should get edit" do
    get profissional_funcoes_edit_url
    assert_response :success
  end

  test "should get update" do
    get profissional_funcoes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get profissional_funcoes_destroy_url
    assert_response :success
  end
end
