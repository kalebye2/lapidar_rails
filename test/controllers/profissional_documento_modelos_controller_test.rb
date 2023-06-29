require "test_helper"

class ProfissionalDocumentoModelosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get profissional_documento_modelos_index_url
    assert_response :success
  end

  test "should get show" do
    get profissional_documento_modelos_show_url
    assert_response :success
  end

  test "should get new" do
    get profissional_documento_modelos_new_url
    assert_response :success
  end

  test "should get edit" do
    get profissional_documento_modelos_edit_url
    assert_response :success
  end
end
