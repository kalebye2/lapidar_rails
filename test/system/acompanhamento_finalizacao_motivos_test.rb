require "application_system_test_case"

class AcompanhamentoFinalizacaoMotivosTest < ApplicationSystemTestCase
  setup do
    @acompanhamento_finalizacao_motivo = acompanhamento_finalizacao_motivos(:one)
  end

  test "visiting the index" do
    visit acompanhamento_finalizacao_motivos_url
    assert_selector "h1", text: "Acompanhamento finalizacao motivos"
  end

  test "should create acompanhamento finalizacao motivo" do
    visit acompanhamento_finalizacao_motivos_url
    click_on "New acompanhamento finalizacao motivo"

    fill_in "Motivo", with: @acompanhamento_finalizacao_motivo.motivo
    click_on "Create Acompanhamento finalizacao motivo"

    assert_text "Acompanhamento finalizacao motivo was successfully created"
    click_on "Back"
  end

  test "should update Acompanhamento finalizacao motivo" do
    visit acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo)
    click_on "Edit this acompanhamento finalizacao motivo", match: :first

    fill_in "Motivo", with: @acompanhamento_finalizacao_motivo.motivo
    click_on "Update Acompanhamento finalizacao motivo"

    assert_text "Acompanhamento finalizacao motivo was successfully updated"
    click_on "Back"
  end

  test "should destroy Acompanhamento finalizacao motivo" do
    visit acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo)
    click_on "Destroy this acompanhamento finalizacao motivo", match: :first

    assert_text "Acompanhamento finalizacao motivo was successfully destroyed"
  end
end
