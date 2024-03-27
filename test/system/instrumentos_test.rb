require "application_system_test_case"

class InstrumentosTest < ApplicationSystemTestCase
  setup do
    @instrumento = instrumentos(:one)
  end

  test "visiting the index" do
    visit instrumentos_url
    assert_selector "h1", text: "Instrumentos"
  end

  test "should create instrumento" do
    visit instrumentos_url
    click_on "New instrumento"

    fill_in "Aplicacao", with: @instrumento.aplicacao
    check "Cronometrado" if @instrumento.cronometrado
    check "Exclusivo psicologo" if @instrumento.exclusivo_psicologo
    fill_in "Faixa etaria meses final", with: @instrumento.faixa_etaria_meses_final
    fill_in "Faixa etaria meses inicio", with: @instrumento.faixa_etaria_meses_inicio
    fill_in "Indicacao", with: @instrumento.indicacao
    fill_in "Instrumento tipo", with: @instrumento.instrumento_tipo_id
    fill_in "Material", with: @instrumento.material
    fill_in "Nome", with: @instrumento.nome
    fill_in "Objetivo", with: @instrumento.objetivo
    fill_in "Particularidades", with: @instrumento.particularidades
    check "Tem na clinica" if @instrumento.tem_na_clinica
    click_on "Create Instrumento"

    assert_text "Instrumento was successfully created"
    click_on "Back"
  end

  test "should update Instrumento" do
    visit instrumento_url(@instrumento)
    click_on "Edit this instrumento", match: :first

    fill_in "Aplicacao", with: @instrumento.aplicacao
    check "Cronometrado" if @instrumento.cronometrado
    check "Exclusivo psicologo" if @instrumento.exclusivo_psicologo
    fill_in "Faixa etaria meses final", with: @instrumento.faixa_etaria_meses_final
    fill_in "Faixa etaria meses inicio", with: @instrumento.faixa_etaria_meses_inicio
    fill_in "Indicacao", with: @instrumento.indicacao
    fill_in "Instrumento tipo", with: @instrumento.instrumento_tipo_id
    fill_in "Material", with: @instrumento.material
    fill_in "Nome", with: @instrumento.nome
    fill_in "Objetivo", with: @instrumento.objetivo
    fill_in "Particularidades", with: @instrumento.particularidades
    check "Tem na clinica" if @instrumento.tem_na_clinica
    click_on "Update Instrumento"

    assert_text "Instrumento was successfully updated"
    click_on "Back"
  end

  test "should destroy Instrumento" do
    visit instrumento_url(@instrumento)
    click_on "Destroy this instrumento", match: :first

    assert_text "Instrumento was successfully destroyed"
  end
end
