require "test_helper"

class AcompanhamentoReajusteMotivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @acompanhamento_reajuste_motivo = acompanhamento_reajuste_motivos(:one)
  end

  test "should get index" do
    get acompanhamento_reajuste_motivos_url
    assert_response :success
  end

  test "should get new" do
    get new_acompanhamento_reajuste_motivo_url
    assert_response :success
  end

  test "should create acompanhamento_reajuste_motivo" do
    assert_difference("AcompanhamentoReajusteMotivo.count") do
      post acompanhamento_reajuste_motivos_url, params: { acompanhamento_reajuste_motivo: {  } }
    end

    assert_redirected_to acompanhamento_reajuste_motivo_url(AcompanhamentoReajusteMotivo.last)
  end

  test "should show acompanhamento_reajuste_motivo" do
    get acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo)
    assert_response :success
  end

  test "should update acompanhamento_reajuste_motivo" do
    patch acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo), params: { acompanhamento_reajuste_motivo: {  } }
    assert_redirected_to acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo)
  end

  test "should destroy acompanhamento_reajuste_motivo" do
    assert_difference("AcompanhamentoReajusteMotivo.count", -1) do
      delete acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo)
    end

    assert_redirected_to acompanhamento_reajuste_motivos_url
  end
end
