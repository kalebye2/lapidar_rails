require "application_system_test_case"

class PaisesTest < ApplicationSystemTestCase
  setup do
    @pais = paises(:one)
  end

  test "visiting the index" do
    visit paises_url
    assert_selector "h1", text: "Paises"
  end

  test "creating a Pais" do
    visit paises_url
    click_on "New Pais"

    fill_in "Continente", with: @pais.continente_id
    fill_in "Iso 3166 numerico", with: @pais.iso_3166_numerico
    fill_in "Nome", with: @pais.nome
    fill_in "Nome ingles", with: @pais.nome_ingles
    fill_in "Nome oficial", with: @pais.nome_oficial
    fill_in "Sigla 2", with: @pais.sigla_2
    fill_in "Sigla 3", with: @pais.sigla_3
    click_on "Create Pais"

    assert_text "Pais was successfully created"
    click_on "Back"
  end

  test "updating a Pais" do
    visit paises_url
    click_on "Edit", match: :first

    fill_in "Continente", with: @pais.continente_id
    fill_in "Iso 3166 numerico", with: @pais.iso_3166_numerico
    fill_in "Nome", with: @pais.nome
    fill_in "Nome ingles", with: @pais.nome_ingles
    fill_in "Nome oficial", with: @pais.nome_oficial
    fill_in "Sigla 2", with: @pais.sigla_2
    fill_in "Sigla 3", with: @pais.sigla_3
    click_on "Update Pais"

    assert_text "Pais was successfully updated"
    click_on "Back"
  end

  test "destroying a Pais" do
    visit paises_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pais was successfully destroyed"
  end
end
