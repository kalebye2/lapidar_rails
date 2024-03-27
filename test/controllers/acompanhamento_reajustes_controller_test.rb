require "test_helper"

class AcompanhamentoReajustesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @acompanhamento_reajuste = acompanhamento_reajustes(:one)
  end

  test "should get index" do
    get acompanhamento_reajustes_url
    assert_response :success
  end

  test "should get new" do
    get new_acompanhamento_reajuste_url
    assert_response :success
  end

  test "should create acompanhamento_reajuste" do
    assert_difference("AcompanhamentoReajuste.count") do
      post acompanhamento_reajustes_url, params: { acompanhamento_reajuste: { acompanhamento_id: @acompanhamento_reajuste.acompanhamento_id, acompanhamento_reajuste_motivo_id: @acompanhamento_reajuste.acompanhamento_reajuste_motivo_id, data_ajuste: @acompanhamento_reajuste.data_ajuste, data_negociacao: @acompanhamento_reajuste.data_negociacao, valor_novo: @acompanhamento_reajuste.valor_novo } }
    end

    assert_redirected_to acompanhamento_reajuste_url(AcompanhamentoReajuste.last)
  end

  test "should show acompanhamento_reajuste" do
    get acompanhamento_reajuste_url(@acompanhamento_reajuste)
    assert_response :success
  end

  test "should get edit" do
    get edit_acompanhamento_reajuste_url(@acompanhamento_reajuste)
    assert_response :success
  end

  test "should update acompanhamento_reajuste" do
    patch acompanhamento_reajuste_url(@acompanhamento_reajuste), params: { acompanhamento_reajuste: { acompanhamento_id: @acompanhamento_reajuste.acompanhamento_id, acompanhamento_reajuste_motivo_id: @acompanhamento_reajuste.acompanhamento_reajuste_motivo_id, data_ajuste: @acompanhamento_reajuste.data_ajuste, data_negociacao: @acompanhamento_reajuste.data_negociacao, valor_novo: @acompanhamento_reajuste.valor_novo } }
    assert_redirected_to acompanhamento_reajuste_url(@acompanhamento_reajuste)
  end

  test "should destroy acompanhamento_reajuste" do
    assert_difference("AcompanhamentoReajuste.count", -1) do
      delete acompanhamento_reajuste_url(@acompanhamento_reajuste)
    end

    assert_redirected_to acompanhamento_reajustes_url
  end
end
