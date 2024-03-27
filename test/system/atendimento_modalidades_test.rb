require "application_system_test_case"

class AtendimentoModalidadesTest < ApplicationSystemTestCase
  setup do
    @atendimento_modalidade = atendimento_modalidades(:one)
  end

  test "visiting the index" do
    visit atendimento_modalidades_url
    assert_selector "h1", text: "Atendimento modalidades"
  end

  test "should create atendimento modalidade" do
    visit atendimento_modalidades_url
    click_on "New atendimento modalidade"

    fill_in "Modalidade", with: @atendimento_modalidade.modalidade
    click_on "Create Atendimento modalidade"

    assert_text "Atendimento modalidade was successfully created"
    click_on "Back"
  end

  test "should update Atendimento modalidade" do
    visit atendimento_modalidade_url(@atendimento_modalidade)
    click_on "Edit this atendimento modalidade", match: :first

    fill_in "Modalidade", with: @atendimento_modalidade.modalidade
    click_on "Update Atendimento modalidade"

    assert_text "Atendimento modalidade was successfully updated"
    click_on "Back"
  end

  test "should destroy Atendimento modalidade" do
    visit atendimento_modalidade_url(@atendimento_modalidade)
    click_on "Destroy this atendimento modalidade", match: :first

    assert_text "Atendimento modalidade was successfully destroyed"
  end
end
