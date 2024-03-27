require "application_system_test_case"

class AtendimentoPlataformasTest < ApplicationSystemTestCase
  setup do
    @atendimento_plataforma = atendimento_plataformas(:one)
  end

  test "visiting the index" do
    visit atendimento_plataformas_url
    assert_selector "h1", text: "Atendimento plataformas"
  end

  test "should create atendimento plataforma" do
    visit atendimento_plataformas_url
    click_on "New atendimento plataforma"

    fill_in "Descricao", with: @atendimento_plataforma.descricao
    fill_in "Nome", with: @atendimento_plataforma.nome
    fill_in "Site", with: @atendimento_plataforma.site
    fill_in "Taxa atendimento", with: @atendimento_plataforma.taxa_atendimento
    fill_in "Taxa fixa", with: @atendimento_plataforma.taxa_fixa
    click_on "Create Atendimento plataforma"

    assert_text "Atendimento plataforma was successfully created"
    click_on "Back"
  end

  test "should update Atendimento plataforma" do
    visit atendimento_plataforma_url(@atendimento_plataforma)
    click_on "Edit this atendimento plataforma", match: :first

    fill_in "Descricao", with: @atendimento_plataforma.descricao
    fill_in "Nome", with: @atendimento_plataforma.nome
    fill_in "Site", with: @atendimento_plataforma.site
    fill_in "Taxa atendimento", with: @atendimento_plataforma.taxa_atendimento
    fill_in "Taxa fixa", with: @atendimento_plataforma.taxa_fixa
    click_on "Update Atendimento plataforma"

    assert_text "Atendimento plataforma was successfully updated"
    click_on "Back"
  end

  test "should destroy Atendimento plataforma" do
    visit atendimento_plataforma_url(@atendimento_plataforma)
    click_on "Destroy this atendimento plataforma", match: :first

    assert_text "Atendimento plataforma was successfully destroyed"
  end
end
