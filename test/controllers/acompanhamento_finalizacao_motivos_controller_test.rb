require "test_helper"

class AcompanhamentoFinalizacaoMotivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @acompanhamento_finalizacao_motivo = acompanhamento_finalizacao_motivos(:one)
  end

  test "should get index" do
    get acompanhamento_finalizacao_motivos_url
    assert_response :success
  end

  test "should get new" do
    get new_acompanhamento_finalizacao_motivo_url
    assert_response :success
  end

  test "should create acompanhamento_finalizacao_motivo" do
    assert_difference("AcompanhamentoFinalizacaoMotivo.count") do
      post acompanhamento_finalizacao_motivos_url, params: { acompanhamento_finalizacao_motivo: { motivo: @acompanhamento_finalizacao_motivo.motivo } }
    end

    assert_redirected_to acompanhamento_finalizacao_motivo_url(AcompanhamentoFinalizacaoMotivo.last)
  end

  test "should show acompanhamento_finalizacao_motivo" do
    get acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo)
    assert_response :success
  end

  test "should update acompanhamento_finalizacao_motivo" do
    patch acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo), params: { acompanhamento_finalizacao_motivo: { motivo: @acompanhamento_finalizacao_motivo.motivo } }
    assert_redirected_to acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo)
  end

  test "should destroy acompanhamento_finalizacao_motivo" do
    assert_difference("AcompanhamentoFinalizacaoMotivo.count", -1) do
      delete acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo)
    end

    assert_redirected_to acompanhamento_finalizacao_motivos_url
  end
end
