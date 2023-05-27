require "test_helper"

class AtendimentoValoresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get atendimento_valores_index_url
    assert_response :success
  end

  test "should get index_pdf" do
    get atendimento_valores_index_pdf_url
    assert_response :success
  end

  test "should get show" do
    get atendimento_valores_show_url
    assert_response :success
  end

  test "should get show_pdf" do
    get atendimento_valores_show_pdf_url
    assert_response :success
  end

  test "should get new" do
    get atendimento_valores_new_url
    assert_response :success
  end

  test "should get create" do
    get atendimento_valores_create_url
    assert_response :success
  end

  test "should get edit" do
    get atendimento_valores_edit_url
    assert_response :success
  end

  test "should get update" do
    get atendimento_valores_update_url
    assert_response :success
  end

  test "should get delete" do
    get atendimento_valores_delete_url
    assert_response :success
  end
end
