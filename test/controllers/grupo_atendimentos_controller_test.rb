require "test_helper"

class GrupoAtendimentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grupo_atendimento = grupo_atendimentos(:one)
  end

  test "should get index" do
    get grupo_atendimentos_url
    assert_response :success
  end

  test "should get new" do
    get new_grupo_atendimento_url
    assert_response :success
  end

  test "should create grupo_atendimento" do
    assert_difference("GrupoAtendimento.count") do
      post grupo_atendimentos_url, params: { grupo_atendimento: { anotacoes: @grupo_atendimento.anotacoes, atendimento_local_id: @grupo_atendimento.atendimento_local_id, avancos: @grupo_atendimento.avancos, data: @grupo_atendimento.data, grupo_id: @grupo_atendimento.grupo_id, horario: @grupo_atendimento.horario, horario_fim: @grupo_atendimento.horario_fim, limitacoes: @grupo_atendimento.limitacoes, modalidade_id: @grupo_atendimento.modalidade_id } }
    end

    assert_redirected_to grupo_atendimento_url(GrupoAtendimento.last)
  end

  test "should show grupo_atendimento" do
    get grupo_atendimento_url(@grupo_atendimento)
    assert_response :success
  end

  test "should get edit" do
    get edit_grupo_atendimento_url(@grupo_atendimento)
    assert_response :success
  end

  test "should update grupo_atendimento" do
    patch grupo_atendimento_url(@grupo_atendimento), params: { grupo_atendimento: { anotacoes: @grupo_atendimento.anotacoes, atendimento_local_id: @grupo_atendimento.atendimento_local_id, avancos: @grupo_atendimento.avancos, data: @grupo_atendimento.data, grupo_id: @grupo_atendimento.grupo_id, horario: @grupo_atendimento.horario, horario_fim: @grupo_atendimento.horario_fim, limitacoes: @grupo_atendimento.limitacoes, modalidade_id: @grupo_atendimento.modalidade_id } }
    assert_redirected_to grupo_atendimento_url(@grupo_atendimento)
  end

  test "should destroy grupo_atendimento" do
    assert_difference("GrupoAtendimento.count", -1) do
      delete grupo_atendimento_url(@grupo_atendimento)
    end

    assert_redirected_to grupo_atendimentos_url
  end
end
