require "application_system_test_case"

class AtendimentoTiposTest < ApplicationSystemTestCase
  setup do
    @atendimento_tipo = atendimento_tipos(:one)
  end

  test "visiting the index" do
    visit atendimento_tipos_url
    assert_selector "h1", text: "Atendimento tipos"
  end

  test "should create atendimento tipo" do
    visit atendimento_tipos_url
    click_on "New atendimento tipo"

    fill_in "Profissional funcao", with: @atendimento_tipo.profissional_funcao_id
    fill_in "Tipo", with: @atendimento_tipo.tipo
    click_on "Create Atendimento tipo"

    assert_text "Atendimento tipo was successfully created"
    click_on "Back"
  end

  test "should update Atendimento tipo" do
    visit atendimento_tipo_url(@atendimento_tipo)
    click_on "Edit this atendimento tipo", match: :first

    fill_in "Profissional funcao", with: @atendimento_tipo.profissional_funcao_id
    fill_in "Tipo", with: @atendimento_tipo.tipo
    click_on "Update Atendimento tipo"

    assert_text "Atendimento tipo was successfully updated"
    click_on "Back"
  end

  test "should destroy Atendimento tipo" do
    visit atendimento_tipo_url(@atendimento_tipo)
    click_on "Destroy this atendimento tipo", match: :first

    assert_text "Atendimento tipo was successfully destroyed"
  end
end
