json.extract! pessoa, :id, :nome, :sobrenome, :cpf, :fone_cod_pais, :fone_cod_area, :fone_num, :feminino, :civil_estado_id, :instrucao_grau_id, :data_nascimento, :email, :pais_id, :estado, :cidade, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :preferencia_contato
json.url pessoa_url(pessoa, format: :json)
