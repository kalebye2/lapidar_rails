json.extract! grupo_atendimento, :id, :grupo_id, :data, :horario, :horario_fim, :modalidade_id, :atendimento_local_id, :anotacoes, :avancos, :limitacoes, :created_at, :updated_at
json.url grupo_atendimento_url(grupo_atendimento, format: :json)
