require "application_system_test_case"

class ProfissionalHorariosTest < ApplicationSystemTestCase
  setup do
    @profissional_horario = profissional_horarios(:one)
  end

  test "visiting the index" do
    visit profissional_horarios_url
    assert_selector "h1", text: "Profissional horarios"
  end

  test "should create profissional horario" do
    visit profissional_horarios_url
    click_on "New profissional horario"

    fill_in "Horario", with: @profissional_horario.horario
    fill_in "Profissional", with: @profissional_horario.profissional_id
    fill_in "Semana dia", with: @profissional_horario.semana_dia_id
    click_on "Create Profissional horario"

    assert_text "Profissional horario was successfully created"
    click_on "Back"
  end

  test "should update Profissional horario" do
    visit profissional_horario_url(@profissional_horario)
    click_on "Edit this profissional horario", match: :first

    fill_in "Horario", with: @profissional_horario.horario
    fill_in "Profissional", with: @profissional_horario.profissional_id
    fill_in "Semana dia", with: @profissional_horario.semana_dia_id
    click_on "Update Profissional horario"

    assert_text "Profissional horario was successfully updated"
    click_on "Back"
  end

  test "should destroy Profissional horario" do
    visit profissional_horario_url(@profissional_horario)
    click_on "Destroy this profissional horario", match: :first

    assert_text "Profissional horario was successfully destroyed"
  end
end
