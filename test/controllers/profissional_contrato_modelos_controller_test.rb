require "test_helper"

class ProfissionalContratoModelosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get profissional_contrato_modelos_index_url
    assert_response :success
  end

  test "should get show" do
    get profissional_contrato_modelos_show_url
    assert_response :success
  end

  test "should get new" do
    get profissional_contrato_modelos_new_url
    assert_response :success
  end

  test "should get create" do
    get profissional_contrato_modelos_create_url
    assert_response :success
  end

  test "should get edit" do
    get profissional_contrato_modelos_edit_url
    assert_response :success
  end

  test "should get update" do
    get profissional_contrato_modelos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get profissional_contrato_modelos_destroy_url
    assert_response :success
  end
end
