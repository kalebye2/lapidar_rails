class EstatisticasController < ApplicationController
  before_action :validar_usuario

  def index
    params[:atendimentos_desde] = params[:atendimentos_desde]&.to_date || Date.today.beginning_of_month
    params[:atendimentos_ate] = params[:atendimentos_ate]&.to_date || Date.today.end_of_month
    @atendimentos = Atendimento.where(data: [params[:atendimentos_desde]..params[:atendimentos_ate]]) || Atendimento.deste_mes

    @acompanhamentos = Acompanhamento.all

    params[:financeiro_desde] = params[:financeiro_desde]&.to_date || Date.today.beginning_of_month
    params[:financeiro_ate] = params[:financeiro_ate]&.to_date || Date.today.end_of_month
    @recebimentos = Recebimento.do_periodo(params[:financeiro_desde]..params[:financeiro_ate]) || Recebimento.do_mes_atual
    @repasses = ProfissionalFinanceiroRepasse.do_periodo(params[:financeiro_desde]..params[:financeiro_ate]) || ProfissionalFinanceiroRepasse.do_mes_atual
    @atendimento_valores = AtendimentoValor.do_periodo(params[:financeiro_desde]..params[:financeiro_ate]) || AtendimentoValor.do_mes_atual

    @finparams = [params[:financeiro_desde], params[:financeiro_ate]]
  end

  def clinica
  end

  def acompanhamentos
  end

  def atendimentos
  end

  def profissionais
  end

  def pacientes
  end

  def instrumentos
  end

  def financeiro
  end

  private

  def validar_usuario
    if !usuario_atual
      erro403
      return
    end
  end
end
