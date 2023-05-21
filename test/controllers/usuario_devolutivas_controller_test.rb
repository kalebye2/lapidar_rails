require 'test_helper'

class UsuarioDevolutivasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usuario_devolutiva = usuario_devolutivas(:one)
  end

  test "should get index" do
    get usuario_devolutivas_url
    assert_response :success
  end

  test "should get new" do
    get new_usuario_devolutiva_url
    assert_response :success
  end

  test "should create usuario_devolutiva" do
    assert_difference('UsuarioDevolutiva.count') do
      post usuario_devolutivas_url, params: { usuario_devolutiva: { data: @usuario_devolutiva.data, feedback_responsavel: @usuario_devolutiva.feedback_responsavel, orientacoes_profissional: @usuario_devolutiva.orientacoes_profissional, profissional_id: @usuario_devolutiva.profissional_id, usuario_id: @usuario_devolutiva.usuario_id, usuario_responsavel_id: @usuario_devolutiva.usuario_responsavel_id } }
    end

    assert_redirected_to usuario_devolutiva_url(UsuarioDevolutiva.last)
  end

  test "should show usuario_devolutiva" do
    get usuario_devolutiva_url(@usuario_devolutiva)
    assert_response :success
  end

  test "should get edit" do
    get edit_usuario_devolutiva_url(@usuario_devolutiva)
    assert_response :success
  end

  test "should update usuario_devolutiva" do
    patch usuario_devolutiva_url(@usuario_devolutiva), params: { usuario_devolutiva: { data: @usuario_devolutiva.data, feedback_responsavel: @usuario_devolutiva.feedback_responsavel, orientacoes_profissional: @usuario_devolutiva.orientacoes_profissional, profissional_id: @usuario_devolutiva.profissional_id, usuario_id: @usuario_devolutiva.usuario_id, usuario_responsavel_id: @usuario_devolutiva.usuario_responsavel_id } }
    assert_redirected_to usuario_devolutiva_url(@usuario_devolutiva)
  end

  test "should destroy usuario_devolutiva" do
    assert_difference('UsuarioDevolutiva.count', -1) do
      delete usuario_devolutiva_url(@usuario_devolutiva)
    end

    assert_redirected_to usuario_devolutivas_url
  end
end
