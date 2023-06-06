class FinanceiroController < ApplicationController
  def index
    @recebimentos = Recebimento.all.order(data: :desc).first 10
    @atendimento_valores = AtendimentoValor.joins("JOIN atendimentos ON atendimento_valores.atendimento_id = atendimentos.id").where(atendimentos: {data: [..Date.today]}).order(data: :desc, horario: :desc).first 10
    @acompanhamentos = Acompanhamento.where(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def atendimento_valor
  end

  def recebimento_usuario
  end

  def repasse_profissionais
  end
end
