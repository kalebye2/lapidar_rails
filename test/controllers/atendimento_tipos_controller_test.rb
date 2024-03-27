require "test_helper"

class AtendimentoTiposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @atendimento_tipo = atendimento_tipos(:one)
  end

  test "should get index" do
    get atendimento_tipos_url
    assert_response :success
  end

  test "should get new" do
    get new_atendimento_tipo_url
    assert_response :success
  end

  test "should create atendimento_tipo" do
    assert_difference("AtendimentoTipo.count") do
      post atendimento_tipos_url, params: { atendimento_tipo: { profissional_funcao_id: @atendimento_tipo.profissional_funcao_id, tipo: @atendimento_tipo.tipo } }
    end

    assert_redirected_to atendimento_tipo_url(AtendimentoTipo.last)
  end

  test "should show atendimento_tipo" do
    get atendimento_tipo_url(@atendimento_tipo)
    assert_response :success
  end

  test "should get edit" do
    get edit_atendimento_tipo_url(@atendimento_tipo)
    assert_response :success
  end

  test "should update atendimento_tipo" do
    patch atendimento_tipo_url(@atendimento_tipo), params: { atendimento_tipo: { profissional_funcao_id: @atendimento_tipo.profissional_funcao_id, tipo: @atendimento_tipo.tipo } }
    assert_redirected_to atendimento_tipo_url(@atendimento_tipo)
  end

  test "should destroy atendimento_tipo" do
    assert_difference("AtendimentoTipo.count", -1) do
      delete atendimento_tipo_url(@atendimento_tipo)
    end

    assert_redirected_to atendimento_tipos_url
  end
end
