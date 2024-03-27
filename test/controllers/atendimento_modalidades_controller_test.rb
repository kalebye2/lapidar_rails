require "test_helper"

class AtendimentoModalidadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @atendimento_modalidade = atendimento_modalidades(:one)
  end

  test "should get index" do
    get atendimento_modalidades_url
    assert_response :success
  end

  test "should get new" do
    get new_atendimento_modalidade_url
    assert_response :success
  end

  test "should create atendimento_modalidade" do
    assert_difference("AtendimentoModalidade.count") do
      post atendimento_modalidades_url, params: { atendimento_modalidade: { modalidade: @atendimento_modalidade.modalidade } }
    end

    assert_redirected_to atendimento_modalidade_url(AtendimentoModalidade.last)
  end

  test "should show atendimento_modalidade" do
    get atendimento_modalidade_url(@atendimento_modalidade)
    assert_response :success
  end

  test "should get edit" do
    get edit_atendimento_modalidade_url(@atendimento_modalidade)
    assert_response :success
  end

  test "should update atendimento_modalidade" do
    patch atendimento_modalidade_url(@atendimento_modalidade), params: { atendimento_modalidade: { modalidade: @atendimento_modalidade.modalidade } }
    assert_redirected_to atendimento_modalidade_url(@atendimento_modalidade)
  end

  test "should destroy atendimento_modalidade" do
    assert_difference("AtendimentoModalidade.count", -1) do
      delete atendimento_modalidade_url(@atendimento_modalidade)
    end

    assert_redirected_to atendimento_modalidades_url
  end
end
