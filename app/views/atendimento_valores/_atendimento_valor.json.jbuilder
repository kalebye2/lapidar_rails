json.extract! atendimento_valor, :paciente, :pessoa_responsavel, :atendimento, :acompanhamento, :valor_real, :desconto_real, :taxa_externa_real, :taxa_interna_real
json.url atendimento_valor_url(atendimento_valor, format: :json)
