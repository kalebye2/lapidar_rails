require "application_system_test_case"

class AcompanhamentoReajustesTest < ApplicationSystemTestCase
  setup do
    @acompanhamento_reajuste = acompanhamento_reajustes(:one)
  end

  test "visiting the index" do
    visit acompanhamento_reajustes_url
    assert_selector "h1", text: "Acompanhamento reajustes"
  end

  test "should create acompanhamento reajuste" do
    visit acompanhamento_reajustes_url
    click_on "New acompanhamento reajuste"

    fill_in "Acompanhamento", with: @acompanhamento_reajuste.acompanhamento_id
    fill_in "Acompanhamento reajuste motivo", with: @acompanhamento_reajuste.acompanhamento_reajuste_motivo_id
    fill_in "Data ajuste", with: @acompanhamento_reajuste.data_ajuste
    fill_in "Data negociacao", with: @acompanhamento_reajuste.data_negociacao
    fill_in "Valor novo", with: @acompanhamento_reajuste.valor_novo
    click_on "Create Acompanhamento reajuste"

    assert_text "Acompanhamento reajuste was successfully created"
    click_on "Back"
  end

  test "should update Acompanhamento reajuste" do
    visit acompanhamento_reajuste_url(@acompanhamento_reajuste)
    click_on "Edit this acompanhamento reajuste", match: :first

    fill_in "Acompanhamento", with: @acompanhamento_reajuste.acompanhamento_id
    fill_in "Acompanhamento reajuste motivo", with: @acompanhamento_reajuste.acompanhamento_reajuste_motivo_id
    fill_in "Data ajuste", with: @acompanhamento_reajuste.data_ajuste
    fill_in "Data negociacao", with: @acompanhamento_reajuste.data_negociacao
    fill_in "Valor novo", with: @acompanhamento_reajuste.valor_novo
    click_on "Update Acompanhamento reajuste"

    assert_text "Acompanhamento reajuste was successfully updated"
    click_on "Back"
  end

  test "should destroy Acompanhamento reajuste" do
    visit acompanhamento_reajuste_url(@acompanhamento_reajuste)
    click_on "Destroy this acompanhamento reajuste", match: :first

    assert_text "Acompanhamento reajuste was successfully destroyed"
  end
end
