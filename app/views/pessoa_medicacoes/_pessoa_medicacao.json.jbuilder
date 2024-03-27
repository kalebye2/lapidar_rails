json.extract! pessoa_medicacao, :id, :pessoa_id, :medicacao, :dose, :motivo, :data_inicio, :data_final, :created_at, :updated_at
json.url pessoa_medicacao_url(pessoa_medicacao, format: :json)
