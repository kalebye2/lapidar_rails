json.extract! acompanhamento_reajuste, :id, :acompanhamento, :data_ajuste, :valor_novo, :data_negociacao, :acompanhamento_reajuste_motivo
json.url acompanhamento_reajuste_url(acompanhamento_reajuste, format: :json)
