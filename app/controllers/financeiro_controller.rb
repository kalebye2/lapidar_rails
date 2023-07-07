class FinanceiroController < ApplicationController
  before_action :validar_usuario

  def index
    if usuario_atual.financeiro?
      @recebimentos = Recebimento.all.order(data: :desc).first 10
      @atendimento_valores = AtendimentoValor.joins("JOIN atendimentos ON atendimento_valores.atendimento_id = atendimentos.id").where(atendimentos: {data: [..Date.today]}).order(data: :desc, horario: :desc).first 10
      @profissional_financeiro_repasses = ProfissionalFinanceiroRepasse.order(data: :desc).first 10
      @acompanhamentos = Acompanhamento.where(data_final: nil, acompanhamento_finalizacao_motivo: nil)
      @profissionais = Profissional.all
    elsif usuario_atual.corpo_clinico?
      @recebimentos = usuario_atual.profissional.recebimentos.order(data: :desc).first 10
      @atendimento_valores = usuario_atual.profissional.atendimento_valores.joins(:atendimento).where("atendimentos.data" => [..Date.today]).order("atendimentos.data" => :desc, "atendimentos.horario" => :desc).first 10
      @profissional_financeiro_repasses = usuario_atual.profissional.repasses.order(data: :desc).first 10
      @profissionais = Profissional.where(id: usuario_atual.profissional.id)
      @acompanhamentos = usuario_atual.profissional.acompanhamentos
    end
  end

  def atendimento_valor
  end

  def recebimento_usuario
  end

  def repasse_profissionais
  end

  private

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.corpo_clinico? || usuario_atual.financeiro?)
      render file: "#{Rails.root}/public/404.html", status: 404
    end
  end
end
