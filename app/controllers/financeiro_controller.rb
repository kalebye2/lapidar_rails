class FinanceiroController < ApplicationController

  def index
    @recebimentos = Recebimento.all.order(data: :desc).last 10
    @atendimento_valores = AtendimentoValor.joins("JOIN atendimentos on atendimento_valores.atendimento_id = atendimentos.id").order(data: :desc, horario: :desc).first 10
  end

  def atendimento_valor
  end

  def recebimento_usuario
  end

  def repasse_profissionais
  end
end
