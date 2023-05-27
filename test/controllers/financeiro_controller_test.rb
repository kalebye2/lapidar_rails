require "test_helper"

class FinanceiroControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get financeiro_index_url
    assert_response :success
  end

  test "should get atendimento_valor" do
    get financeiro_atendimento_valor_url
    assert_response :success
  end

  test "should get recebimento_usuario" do
    get financeiro_recebimento_usuario_url
    assert_response :success
  end

  test "should get repasse_profissionais" do
    get financeiro_repasse_profissionais_url
    assert_response :success
  end
end
