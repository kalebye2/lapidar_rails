json.id pessoa_devolutiva.id
json.pessoa pessoa_devolutiva.pessoa, :id, :nome_completo, :cpf, :rg, :data_nascimento, :idade_anos, :profissao
json.interessado pessoa_devolutiva.pessoa_interessada, :id, :nome_completo, :cpf, :rg, :data_nascimento, :idade_anos, :profissao
json.parentesco_interessado pessoa_devolutiva.pessoa.grau_parentesco(pessoa_devolutiva.pessoa_interessada)&.parentesco
# json.extract! pessoa_devolutiva, *pessoa_devolutiva.attribute_names
json.extract! pessoa_devolutiva, :pontos_a_abordar, :feedback_responsavel, :orientacoes_profissional
