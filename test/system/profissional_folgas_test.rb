require "application_system_test_case"

class ProfissionalFolgasTest < ApplicationSystemTestCase
  setup do
    @profissional_folga = profissional_folgas(:one)
  end

  test "visiting the index" do
    visit profissional_folgas_url
    assert_selector "h1", text: "Profissional folgas"
  end

  test "should create profissional folga" do
    visit profissional_folgas_url
    click_on "New profissional folga"

    click_on "Create Profissional folga"

    assert_text "Profissional folga was successfully created"
    click_on "Back"
  end

  test "should update Profissional folga" do
    visit profissional_folga_url(@profissional_folga)
    click_on "Edit this profissional folga", match: :first

    click_on "Update Profissional folga"

    assert_text "Profissional folga was successfully updated"
    click_on "Back"
  end

  test "should destroy Profissional folga" do
    visit profissional_folga_url(@profissional_folga)
    click_on "Destroy this profissional folga", match: :first

    assert_text "Profissional folga was successfully destroyed"
  end
end
