require "test_helper"

class AtendimentoLocalTiposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @atendimento_local_tipo = atendimento_local_tipos(:one)
  end

  test "should get index" do
    get atendimento_local_tipos_url
    assert_response :success
  end

  test "should get new" do
    get new_atendimento_local_tipo_url
    assert_response :success
  end

  test "should create atendimento_local_tipo" do
    assert_difference("AtendimentoLocalTipo.count") do
      post atendimento_local_tipos_url, params: { atendimento_local_tipo: { tipo: @atendimento_local_tipo.tipo } }
    end

    assert_redirected_to atendimento_local_tipo_url(AtendimentoLocalTipo.last)
  end

  test "should show atendimento_local_tipo" do
    get atendimento_local_tipo_url(@atendimento_local_tipo)
    assert_response :success
  end

  test "should get edit" do
    get edit_atendimento_local_tipo_url(@atendimento_local_tipo)
    assert_response :success
  end

  test "should update atendimento_local_tipo" do
    patch atendimento_local_tipo_url(@atendimento_local_tipo), params: { atendimento_local_tipo: { tipo: @atendimento_local_tipo.tipo } }
    assert_redirected_to atendimento_local_tipo_url(@atendimento_local_tipo)
  end

  test "should destroy atendimento_local_tipo" do
    assert_difference("AtendimentoLocalTipo.count", -1) do
      delete atendimento_local_tipo_url(@atendimento_local_tipo)
    end

    assert_redirected_to atendimento_local_tipos_url
  end
end
