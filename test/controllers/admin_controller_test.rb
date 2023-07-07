require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get acompanhamento_finalizacao_motivos" do
    get admin_acompanhamento_finalizacao_motivos_url
    assert_response :success
  end

  test "should get acompanhamento_tipos" do
    get admin_acompanhamento_tipos_url
    assert_response :success
  end

  test "should get atendimento_locais" do
    get admin_atendimento_locais_url
    assert_response :success
  end

  test "should get atendimento_local_tipos" do
    get admin_atendimento_local_tipos_url
    assert_response :success
  end

  test "should get atendimento_modalidades" do
    get admin_atendimento_modalidades_url
    assert_response :success
  end

  test "should get atendimento_plataformas" do
    get admin_atendimento_plataformas_url
    assert_response :success
  end

  test "should get atendimento_tipos" do
    get admin_atendimento_tipos_url
    assert_response :success
  end

  test "should get civil_estados" do
    get admin_civil_estados_url
    assert_response :success
  end

  test "should get profissional_funcoes" do
    get admin_profissional_funcoes_url
    assert_response :success
  end
end
