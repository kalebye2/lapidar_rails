require "application_system_test_case"

class AcompanhamentoReajusteMotivosTest < ApplicationSystemTestCase
  setup do
    @acompanhamento_reajuste_motivo = acompanhamento_reajuste_motivos(:one)
  end

  test "visiting the index" do
    visit acompanhamento_reajuste_motivos_url
    assert_selector "h1", text: "Acompanhamento reajuste motivos"
  end

  test "should create acompanhamento reajuste motivo" do
    visit acompanhamento_reajuste_motivos_url
    click_on "New acompanhamento reajuste motivo"

    click_on "Create Acompanhamento reajuste motivo"

    assert_text "Acompanhamento reajuste motivo was successfully created"
    click_on "Back"
  end

  test "should update Acompanhamento reajuste motivo" do
    visit acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo)
    click_on "Edit this acompanhamento reajuste motivo", match: :first

    click_on "Update Acompanhamento reajuste motivo"

    assert_text "Acompanhamento reajuste motivo was successfully updated"
    click_on "Back"
  end

  test "should destroy Acompanhamento reajuste motivo" do
    visit acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo)
    click_on "Destroy this acompanhamento reajuste motivo", match: :first

    assert_text "Acompanhamento reajuste motivo was successfully destroyed"
  end
end
