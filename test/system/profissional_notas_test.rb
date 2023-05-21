require "application_system_test_case"

class ProfissionalNotasTest < ApplicationSystemTestCase
  setup do
    @profissional_nota = profissional_notas(:one)
  end

  test "visiting the index" do
    visit profissional_notas_url
    assert_selector "h1", text: "Profissional Notas"
  end

  test "creating a Profissional nota" do
    visit profissional_notas_url
    click_on "New Profissional Nota"

    fill_in "Data", with: @profissional_nota.data
    fill_in "Data lembrar", with: @profissional_nota.data_lembrar
    fill_in "Hora", with: @profissional_nota.hora
    fill_in "Hora lembrar", with: @profissional_nota.hora_lembrar
    fill_in "Nota", with: @profissional_nota.nota
    fill_in "Profissional", with: @profissional_nota.profissional_id
    click_on "Create Profissional nota"

    assert_text "Profissional nota was successfully created"
    click_on "Back"
  end

  test "updating a Profissional nota" do
    visit profissional_notas_url
    click_on "Edit", match: :first

    fill_in "Data", with: @profissional_nota.data
    fill_in "Data lembrar", with: @profissional_nota.data_lembrar
    fill_in "Hora", with: @profissional_nota.hora
    fill_in "Hora lembrar", with: @profissional_nota.hora_lembrar
    fill_in "Nota", with: @profissional_nota.nota
    fill_in "Profissional", with: @profissional_nota.profissional_id
    click_on "Update Profissional nota"

    assert_text "Profissional nota was successfully updated"
    click_on "Back"
  end

  test "destroying a Profissional nota" do
    visit profissional_notas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Profissional nota was successfully destroyed"
  end
end
