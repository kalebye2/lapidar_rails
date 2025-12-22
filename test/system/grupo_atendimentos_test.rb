require "application_system_test_case"

class GrupoAtendimentosTest < ApplicationSystemTestCase
  setup do
    @grupo_atendimento = grupo_atendimentos(:one)
  end

  test "visiting the index" do
    visit grupo_atendimentos_url
    assert_selector "h1", text: "Grupo atendimentos"
  end

  test "should create grupo atendimento" do
    visit grupo_atendimentos_url
    click_on "New grupo atendimento"

    fill_in "Anotacoes", with: @grupo_atendimento.anotacoes
    fill_in "Atendimento local", with: @grupo_atendimento.atendimento_local_id
    fill_in "Avancos", with: @grupo_atendimento.avancos
    fill_in "Data", with: @grupo_atendimento.data
    fill_in "Grupo", with: @grupo_atendimento.grupo_id
    fill_in "Horario", with: @grupo_atendimento.horario
    fill_in "Horario fim", with: @grupo_atendimento.horario_fim
    fill_in "Limitacoes", with: @grupo_atendimento.limitacoes
    fill_in "Modalidade", with: @grupo_atendimento.modalidade_id
    click_on "Create Grupo atendimento"

    assert_text "Grupo atendimento was successfully created"
    click_on "Back"
  end

  test "should update Grupo atendimento" do
    visit grupo_atendimento_url(@grupo_atendimento)
    click_on "Edit this grupo atendimento", match: :first

    fill_in "Anotacoes", with: @grupo_atendimento.anotacoes
    fill_in "Atendimento local", with: @grupo_atendimento.atendimento_local_id
    fill_in "Avancos", with: @grupo_atendimento.avancos
    fill_in "Data", with: @grupo_atendimento.data
    fill_in "Grupo", with: @grupo_atendimento.grupo_id
    fill_in "Horario", with: @grupo_atendimento.horario
    fill_in "Horario fim", with: @grupo_atendimento.horario_fim
    fill_in "Limitacoes", with: @grupo_atendimento.limitacoes
    fill_in "Modalidade", with: @grupo_atendimento.modalidade_id
    click_on "Update Grupo atendimento"

    assert_text "Grupo atendimento was successfully updated"
    click_on "Back"
  end

  test "should destroy Grupo atendimento" do
    visit grupo_atendimento_url(@grupo_atendimento)
    click_on "Destroy this grupo atendimento", match: :first

    assert_text "Grupo atendimento was successfully destroyed"
  end
end
