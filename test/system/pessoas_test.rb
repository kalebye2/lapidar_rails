require "application_system_test_case"

class PessoasTest < ApplicationSystemTestCase
  setup do
    @pessoa = pessoas(:one)
  end

  test "visiting the index" do
    visit pessoas_url
    assert_selector "h1", text: "Pessoas"
  end

  test "creating a Pessoa" do
    visit pessoas_url
    click_on "New Pessoa"

    fill_in "Cidade", with: @pessoa.cidade
    fill_in "Civil estado", with: @pessoa.civil_estado_id
    fill_in "Cpf", with: @pessoa.cpf
    fill_in "Data nascimento", with: @pessoa.data_nascimento
    fill_in "Email", with: @pessoa.email
    fill_in "Endereco cep", with: @pessoa.endereco_cep
    fill_in "Endereco complemento", with: @pessoa.endereco_complemento
    fill_in "Endereco logradouro", with: @pessoa.endereco_logradouro
    fill_in "Endereco numero", with: @pessoa.endereco_numero
    fill_in "Estado", with: @pessoa.estado
    check "Feminino" if @pessoa.feminino
    fill_in "Fone cod area", with: @pessoa.fone_cod_area
    fill_in "Fone cod pais", with: @pessoa.fone_cod_pais
    fill_in "Fone num", with: @pessoa.fone_num
    fill_in "Instrucao grau", with: @pessoa.instrucao_grau_id
    fill_in "Nome", with: @pessoa.nome
    fill_in "Pais", with: @pessoa.pais_id
    fill_in "Preferencia contato", with: @pessoa.preferencia_contato
    fill_in "Sobrenome", with: @pessoa.sobrenome
    click_on "Create Pessoa"

    assert_text "Pessoa was successfully created"
    click_on "Back"
  end

  test "updating a Pessoa" do
    visit pessoas_url
    click_on "Edit", match: :first

    fill_in "Cidade", with: @pessoa.cidade
    fill_in "Civil estado", with: @pessoa.civil_estado_id
    fill_in "Cpf", with: @pessoa.cpf
    fill_in "Data nascimento", with: @pessoa.data_nascimento
    fill_in "Email", with: @pessoa.email
    fill_in "Endereco cep", with: @pessoa.endereco_cep
    fill_in "Endereco complemento", with: @pessoa.endereco_complemento
    fill_in "Endereco logradouro", with: @pessoa.endereco_logradouro
    fill_in "Endereco numero", with: @pessoa.endereco_numero
    fill_in "Estado", with: @pessoa.estado
    check "Feminino" if @pessoa.feminino
    fill_in "Fone cod area", with: @pessoa.fone_cod_area
    fill_in "Fone cod pais", with: @pessoa.fone_cod_pais
    fill_in "Fone num", with: @pessoa.fone_num
    fill_in "Instrucao grau", with: @pessoa.instrucao_grau_id
    fill_in "Nome", with: @pessoa.nome
    fill_in "Pais", with: @pessoa.pais_id
    fill_in "Preferencia contato", with: @pessoa.preferencia_contato
    fill_in "Sobrenome", with: @pessoa.sobrenome
    click_on "Update Pessoa"

    assert_text "Pessoa was successfully updated"
    click_on "Back"
  end

  test "destroying a Pessoa" do
    visit pessoas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pessoa was successfully destroyed"
  end
end
