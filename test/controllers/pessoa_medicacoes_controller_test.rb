require "test_helper"

class PessoaMedicacoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pessoa_medicacao = pessoa_medicacoes(:one)
  end

  test "should get index" do
    get pessoa_medicacoes_url
    assert_response :success
  end

  test "should get new" do
    get new_pessoa_medicacao_url
    assert_response :success
  end

  test "should create pessoa_medicacao" do
    assert_difference("PessoaMedicacao.count") do
      post pessoa_medicacoes_url, params: { pessoa_medicacao: { data_final: @pessoa_medicacao.data_final, data_inicio: @pessoa_medicacao.data_inicio, dose: @pessoa_medicacao.dose, medicacao: @pessoa_medicacao.medicacao, motivo: @pessoa_medicacao.motivo, pessoa_id: @pessoa_medicacao.pessoa_id } }
    end

    assert_redirected_to pessoa_medicacao_url(PessoaMedicacao.last)
  end

  test "should show pessoa_medicacao" do
    get pessoa_medicacao_url(@pessoa_medicacao)
    assert_response :success
  end

  test "should get edit" do
    get edit_pessoa_medicacao_url(@pessoa_medicacao)
    assert_response :success
  end

  test "should update pessoa_medicacao" do
    patch pessoa_medicacao_url(@pessoa_medicacao), params: { pessoa_medicacao: { data_final: @pessoa_medicacao.data_final, data_inicio: @pessoa_medicacao.data_inicio, dose: @pessoa_medicacao.dose, medicacao: @pessoa_medicacao.medicacao, motivo: @pessoa_medicacao.motivo, pessoa_id: @pessoa_medicacao.pessoa_id } }
    assert_redirected_to pessoa_medicacao_url(@pessoa_medicacao)
  end

  test "should destroy pessoa_medicacao" do
    assert_difference("PessoaMedicacao.count", -1) do
      delete pessoa_medicacao_url(@pessoa_medicacao)
    end

    assert_redirected_to pessoa_medicacoes_url
  end
end
