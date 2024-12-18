json.extract! laudo, :id
json.interessado laudo.parte_interessada
json.extract! laudo, :data_avaliacao, :finalidade
json.avaliado laudo.pessoa, :id, :nome_completo, :cpf, :rg, :render_fone_link, :data_nascimento, :estado_civil, :instrucao_grau, :endereco_completo, :profissao
json.acompanhamento laudo.acompanhamento, :id, :motivo, :data_inicio, :data_final
json.profissional laudo.profissional, :id, :funcao, :nome_completo, :documento
json.extract! laudo, :demanda, :tecnicas, :analise, :conclusao, :referencias
json.fechado laudo.fechado
# json.id laudo.id
json.url laudo_url(laudo)
