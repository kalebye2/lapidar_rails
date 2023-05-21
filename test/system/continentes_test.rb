require "application_system_test_case"

class ContinentesTest < ApplicationSystemTestCase
  setup do
    @continente = continentes(:one)
  end

  test "visiting the index" do
    visit continentes_url
    assert_selector "h1", text: "Continentes"
  end

  test "creating a Continente" do
    visit continentes_url
    click_on "New Continente"

    fill_in "Nome", with: @continente.nome
    click_on "Create Continente"

    assert_text "Continente was successfully created"
    click_on "Back"
  end

  test "updating a Continente" do
    visit continentes_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @continente.nome
    click_on "Update Continente"

    assert_text "Continente was successfully updated"
    click_on "Back"
  end

  test "destroying a Continente" do
    visit continentes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Continente was successfully destroyed"
  end
end
