# json.extract! acompanhamento, :id, :pessoa, :profissional, :pessoa_responsavel, :acompanhamento_tipo, :motivo, :atendimento_plataforma, :status, :motivo_da_finalizacao, :data_inicio, :valor_sessao, :valor_sessao_contrato, :num_sessoes, :num_sessoes_contrato, :acompanhamento_horarios
json.id acompanhamento.id
json.tipo acompanhamento.tipo.upcase
json.paciente acompanhamento.pessoa, :id, :nome_completo, :cpf, :rg, :render_fone_link, :email, :profissao
json.profissional acompanhamento.profissional.as_json(methods: [:nome_completo, :funcao, :documento, :email, ], only: [:id])
if acompanhamento.responsavel_legal
  json.responsavel_legal acompanhamento.responsavel_legal, :id, :nome_completo, :cpf, :rg, :render_fone_link, :email, :profissao
end
json.data_inicio acompanhamento.data_inicio
json.status acompanhamento.status
json.motivo_da_finalizacao acompanhamento.motivo_da_finalizacao
json.suspenso acompanhamento.suspenso?
json.valor_sessao acompanhamento.valor_sessao_real
json.num_sessoes acompanhamento.num_sessoes
json.valor_sessao_contrato acompanhamento.valor_sessao_contrato
json.num_sessoes_contrato acompanhamento.num_sessoes_contrato
json.financeiro_reajustes acompanhamento.acompanhamento_reajustes.as_json(except: [:id, :acompanhamento_id, :acompanhamento_reajuste_motivo_id], methods: [:motivo])
json.atendimentos_totais acompanhamento.atendimentos.count
json.atendimentos acompanhamento.atendimentos, :id, :data, :data_inicio_verdadeira, :horario, :horario_inicio_verdadeiro, :horario_fim_verdadeiro, :modalidade, :tipo, :anotacoes
json.atendimentos_realizados acompanhamento.atendimentos.realizados.count
json.atendimentos_futuros acompanhamento.atendimentos.futuros.count
json.data_ultimo_atendimento_realizado acompanhamento.atendimentos.em_ordem(:desc).realizados.first&.data_inicio_verdadeira
json.data_proximo_atendimento acompanhamento.atendimentos.do_periodo(Date.current..).limit(2).last&.data_inicio_verdadeira
json.url acompanhamento_url(acompanhamento, format: :json)
