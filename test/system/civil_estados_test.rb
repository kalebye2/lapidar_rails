require "application_system_test_case"

class CivilEstadosTest < ApplicationSystemTestCase
  setup do
    @civil_estado = civil_estados(:one)
  end

  test "visiting the index" do
    visit civil_estados_url
    assert_selector "h1", text: "Civil estados"
  end

  test "should create civil estado" do
    visit civil_estados_url
    click_on "New civil estado"

    fill_in "Estado", with: @civil_estado.estado
    click_on "Create Civil estado"

    assert_text "Civil estado was successfully created"
    click_on "Back"
  end

  test "should update Civil estado" do
    visit civil_estado_url(@civil_estado)
    click_on "Edit this civil estado", match: :first

    fill_in "Estado", with: @civil_estado.estado
    click_on "Update Civil estado"

    assert_text "Civil estado was successfully updated"
    click_on "Back"
  end

  test "should destroy Civil estado" do
    visit civil_estado_url(@civil_estado)
    click_on "Destroy this civil estado", match: :first

    assert_text "Civil estado was successfully destroyed"
  end
end
