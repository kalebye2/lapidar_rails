json.extract! atendimento, :acompanhamento, :pessoa, :profissional, :pessoa_responsavel, :id, :data, :data_fim, :horario, :horario_fim, :modalidade, :atendimento_tipo, :atendimento_local, :presenca, :anotacoes, :avancos, :limitacoes, :solicitar_reagendamento, :data_reagendamento, :data_reagendamento_fim, :horario_reagendamento, :horario_reagendamento_fim, :atendimento_valor
json.url atendimento_url(atendimento, format: :json)
