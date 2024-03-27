require "test_helper"

class EstatisticasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get estatisticas_index_url
    assert_response :success
  end

  test "should get acompanhamentos" do
    get estatisticas_acompanhamentos_url
    assert_response :success
  end

  test "should get atendimentos" do
    get estatisticas_atendimentos_url
    assert_response :success
  end

  test "should get profissionais" do
    get estatisticas_profissionais_url
    assert_response :success
  end

  test "should get pacientes" do
    get estatisticas_pacientes_url
    assert_response :success
  end

  test "should get instrumentos" do
    get estatisticas_instrumentos_url
    assert_response :success
  end

  test "should get financeiro" do
    get estatisticas_financeiro_url
    assert_response :success
  end
end
