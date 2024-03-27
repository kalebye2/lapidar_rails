require "application_system_test_case"

class AtendimentoLocaisTest < ApplicationSystemTestCase
  setup do
    @atendimento_local = atendimento_locais(:one)
  end

  test "visiting the index" do
    visit atendimento_locais_url
    assert_selector "h1", text: "Atendimento locais"
  end

  test "should create atendimento local" do
    visit atendimento_locais_url
    click_on "New atendimento local"

    fill_in "Atendimento local tipo", with: @atendimento_local.atendimento_local_tipo_id
    fill_in "Cidade", with: @atendimento_local.cidade
    fill_in "Descricao", with: @atendimento_local.descricao
    fill_in "Endereco cep", with: @atendimento_local.endereco_cep
    fill_in "Endereco complemento", with: @atendimento_local.endereco_complemento
    fill_in "Endereco logradouro", with: @atendimento_local.endereco_logradouro
    fill_in "Endereco numero", with: @atendimento_local.endereco_numero
    fill_in "Estado", with: @atendimento_local.estado
    fill_in "Latitude", with: @atendimento_local.latitude
    fill_in "Longitude", with: @atendimento_local.longitude
    fill_in "Pais", with: @atendimento_local.pais_id
    click_on "Create Atendimento local"

    assert_text "Atendimento local was successfully created"
    click_on "Back"
  end

  test "should update Atendimento local" do
    visit atendimento_local_url(@atendimento_local)
    click_on "Edit this atendimento local", match: :first

    fill_in "Atendimento local tipo", with: @atendimento_local.atendimento_local_tipo_id
    fill_in "Cidade", with: @atendimento_local.cidade
    fill_in "Descricao", with: @atendimento_local.descricao
    fill_in "Endereco cep", with: @atendimento_local.endereco_cep
    fill_in "Endereco complemento", with: @atendimento_local.endereco_complemento
    fill_in "Endereco logradouro", with: @atendimento_local.endereco_logradouro
    fill_in "Endereco numero", with: @atendimento_local.endereco_numero
    fill_in "Estado", with: @atendimento_local.estado
    fill_in "Latitude", with: @atendimento_local.latitude
    fill_in "Longitude", with: @atendimento_local.longitude
    fill_in "Pais", with: @atendimento_local.pais_id
    click_on "Update Atendimento local"

    assert_text "Atendimento local was successfully updated"
    click_on "Back"
  end

  test "should destroy Atendimento local" do
    visit atendimento_local_url(@atendimento_local)
    click_on "Destroy this atendimento local", match: :first

    assert_text "Atendimento local was successfully destroyed"
  end
end
