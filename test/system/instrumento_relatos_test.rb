require "application_system_test_case"

class InstrumentoRelatosTest < ApplicationSystemTestCase
  setup do
    @instrumento_relato = instrumento_relatos(:one)
  end

  test "visiting the index" do
    visit instrumento_relatos_url
    assert_selector "h1", text: "Instrumento relatos"
  end

  test "should create instrumento relato" do
    visit instrumento_relatos_url
    click_on "New instrumento relato"

    click_on "Create Instrumento relato"

    assert_text "Instrumento relato was successfully created"
    click_on "Back"
  end

  test "should update Instrumento relato" do
    visit instrumento_relato_url(@instrumento_relato)
    click_on "Edit this instrumento relato", match: :first

    click_on "Update Instrumento relato"

    assert_text "Instrumento relato was successfully updated"
    click_on "Back"
  end

  test "should destroy Instrumento relato" do
    visit instrumento_relato_url(@instrumento_relato)
    click_on "Destroy this instrumento relato", match: :first

    assert_text "Instrumento relato was successfully destroyed"
  end
end
