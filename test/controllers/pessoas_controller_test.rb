require 'test_helper'

class PessoasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pessoa = pessoas(:one)
  end

  test "should get index" do
    get pessoas_url
    assert_response :success
  end

  test "should get new" do
    get new_pessoa_url
    assert_response :success
  end

  test "should create pessoa" do
    assert_difference('Pessoa.count') do
      post pessoas_url, params: { pessoa: { cidade: @pessoa.cidade, civil_estado_id: @pessoa.civil_estado_id, cpf: @pessoa.cpf, data_nascimento: @pessoa.data_nascimento, email: @pessoa.email, endereco_cep: @pessoa.endereco_cep, endereco_complemento: @pessoa.endereco_complemento, endereco_logradouro: @pessoa.endereco_logradouro, endereco_numero: @pessoa.endereco_numero, estado: @pessoa.estado, feminino: @pessoa.feminino, fone_cod_area: @pessoa.fone_cod_area, fone_cod_pais: @pessoa.fone_cod_pais, fone_num: @pessoa.fone_num, instrucao_grau_id: @pessoa.instrucao_grau_id, nome: @pessoa.nome, pais_id: @pessoa.pais_id, preferencia_contato: @pessoa.preferencia_contato, sobrenome: @pessoa.sobrenome } }
    end

    assert_redirected_to pessoa_url(Pessoa.last)
  end

  test "should show pessoa" do
    get pessoa_url(@pessoa)
    assert_response :success
  end

  test "should get edit" do
    get edit_pessoa_url(@pessoa)
    assert_response :success
  end

  test "should update pessoa" do
    patch pessoa_url(@pessoa), params: { pessoa: { cidade: @pessoa.cidade, civil_estado_id: @pessoa.civil_estado_id, cpf: @pessoa.cpf, data_nascimento: @pessoa.data_nascimento, email: @pessoa.email, endereco_cep: @pessoa.endereco_cep, endereco_complemento: @pessoa.endereco_complemento, endereco_logradouro: @pessoa.endereco_logradouro, endereco_numero: @pessoa.endereco_numero, estado: @pessoa.estado, feminino: @pessoa.feminino, fone_cod_area: @pessoa.fone_cod_area, fone_cod_pais: @pessoa.fone_cod_pais, fone_num: @pessoa.fone_num, instrucao_grau_id: @pessoa.instrucao_grau_id, nome: @pessoa.nome, pais_id: @pessoa.pais_id, preferencia_contato: @pessoa.preferencia_contato, sobrenome: @pessoa.sobrenome } }
    assert_redirected_to pessoa_url(@pessoa)
  end

  test "should destroy pessoa" do
    assert_difference('Pessoa.count', -1) do
      delete pessoa_url(@pessoa)
    end

    assert_redirected_to pessoas_url
  end
end
