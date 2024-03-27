require "application_system_test_case"

class AtendimentoLocalTiposTest < ApplicationSystemTestCase
  setup do
    @atendimento_local_tipo = atendimento_local_tipos(:one)
  end

  test "visiting the index" do
    visit atendimento_local_tipos_url
    assert_selector "h1", text: "Atendimento local tipos"
  end

  test "should create atendimento local tipo" do
    visit atendimento_local_tipos_url
    click_on "New atendimento local tipo"

    fill_in "Tipo", with: @atendimento_local_tipo.tipo
    click_on "Create Atendimento local tipo"

    assert_text "Atendimento local tipo was successfully created"
    click_on "Back"
  end

  test "should update Atendimento local tipo" do
    visit atendimento_local_tipo_url(@atendimento_local_tipo)
    click_on "Edit this atendimento local tipo", match: :first

    fill_in "Tipo", with: @atendimento_local_tipo.tipo
    click_on "Update Atendimento local tipo"

    assert_text "Atendimento local tipo was successfully updated"
    click_on "Back"
  end

  test "should destroy Atendimento local tipo" do
    visit atendimento_local_tipo_url(@atendimento_local_tipo)
    click_on "Destroy this atendimento local tipo", match: :first

    assert_text "Atendimento local tipo was successfully destroyed"
  end
end
