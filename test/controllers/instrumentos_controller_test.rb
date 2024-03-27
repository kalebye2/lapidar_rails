require "test_helper"

class InstrumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instrumento = instrumentos(:one)
  end

  test "should get index" do
    get instrumentos_url
    assert_response :success
  end

  test "should get new" do
    get new_instrumento_url
    assert_response :success
  end

  test "should create instrumento" do
    assert_difference("Instrumento.count") do
      post instrumentos_url, params: { instrumento: { aplicacao: @instrumento.aplicacao, cronometrado: @instrumento.cronometrado, exclusivo_psicologo: @instrumento.exclusivo_psicologo, faixa_etaria_meses_final: @instrumento.faixa_etaria_meses_final, faixa_etaria_meses_inicio: @instrumento.faixa_etaria_meses_inicio, indicacao: @instrumento.indicacao, instrumento_tipo_id: @instrumento.instrumento_tipo_id, material: @instrumento.material, nome: @instrumento.nome, objetivo: @instrumento.objetivo, particularidades: @instrumento.particularidades, tem_na_clinica: @instrumento.tem_na_clinica } }
    end

    assert_redirected_to instrumento_url(Instrumento.last)
  end

  test "should show instrumento" do
    get instrumento_url(@instrumento)
    assert_response :success
  end

  test "should get edit" do
    get edit_instrumento_url(@instrumento)
    assert_response :success
  end

  test "should update instrumento" do
    patch instrumento_url(@instrumento), params: { instrumento: { aplicacao: @instrumento.aplicacao, cronometrado: @instrumento.cronometrado, exclusivo_psicologo: @instrumento.exclusivo_psicologo, faixa_etaria_meses_final: @instrumento.faixa_etaria_meses_final, faixa_etaria_meses_inicio: @instrumento.faixa_etaria_meses_inicio, indicacao: @instrumento.indicacao, instrumento_tipo_id: @instrumento.instrumento_tipo_id, material: @instrumento.material, nome: @instrumento.nome, objetivo: @instrumento.objetivo, particularidades: @instrumento.particularidades, tem_na_clinica: @instrumento.tem_na_clinica } }
    assert_redirected_to instrumento_url(@instrumento)
  end

  test "should destroy instrumento" do
    assert_difference("Instrumento.count", -1) do
      delete instrumento_url(@instrumento)
    end

    assert_redirected_to instrumentos_url
  end
end
