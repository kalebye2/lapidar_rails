require "application_system_test_case"

class PessoaMedicacoesTest < ApplicationSystemTestCase
  setup do
    @pessoa_medicacao = pessoa_medicacoes(:one)
  end

  test "visiting the index" do
    visit pessoa_medicacoes_url
    assert_selector "h1", text: "Pessoa medicacoes"
  end

  test "should create pessoa medicacao" do
    visit pessoa_medicacoes_url
    click_on "New pessoa medicacao"

    fill_in "Data final", with: @pessoa_medicacao.data_final
    fill_in "Data inicio", with: @pessoa_medicacao.data_inicio
    fill_in "Dose", with: @pessoa_medicacao.dose
    fill_in "Medicacao", with: @pessoa_medicacao.medicacao
    fill_in "Motivo", with: @pessoa_medicacao.motivo
    fill_in "Pessoa", with: @pessoa_medicacao.pessoa_id
    click_on "Create Pessoa medicacao"

    assert_text "Pessoa medicacao was successfully created"
    click_on "Back"
  end

  test "should update Pessoa medicacao" do
    visit pessoa_medicacao_url(@pessoa_medicacao)
    click_on "Edit this pessoa medicacao", match: :first

    fill_in "Data final", with: @pessoa_medicacao.data_final
    fill_in "Data inicio", with: @pessoa_medicacao.data_inicio
    fill_in "Dose", with: @pessoa_medicacao.dose
    fill_in "Medicacao", with: @pessoa_medicacao.medicacao
    fill_in "Motivo", with: @pessoa_medicacao.motivo
    fill_in "Pessoa", with: @pessoa_medicacao.pessoa_id
    click_on "Update Pessoa medicacao"

    assert_text "Pessoa medicacao was successfully updated"
    click_on "Back"
  end

  test "should destroy Pessoa medicacao" do
    visit pessoa_medicacao_url(@pessoa_medicacao)
    click_on "Destroy this pessoa medicacao", match: :first

    assert_text "Pessoa medicacao was successfully destroyed"
  end
end
