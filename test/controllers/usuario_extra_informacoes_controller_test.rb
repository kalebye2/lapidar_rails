require "test_helper"

class UsuarioExtraInformacoesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get usuario_extra_informacoes_new_url
    assert_response :success
  end

  test "should get create" do
    get usuario_extra_informacoes_create_url
    assert_response :success
  end

  test "should get show" do
    get usuario_extra_informacoes_show_url
    assert_response :success
  end

  test "should get show_pdf" do
    get usuario_extra_informacoes_show_pdf_url
    assert_response :success
  end

  test "should get edit" do
    get usuario_extra_informacoes_edit_url
    assert_response :success
  end

  test "should get delete" do
    get usuario_extra_informacoes_delete_url
    assert_response :success
  end
end
