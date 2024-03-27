class EstatisticasController < ApplicationController
  def index
    params[:atendimentos_desde] = params[:atendimentos_desde]&.to_date || Date.today.beginning_of_month
    params[:atendimentos_ate] = params[:atendimentos_ate]&.to_date || Date.today.end_of_month
    @atendimentos = Atendimento.where(data: [params[:atendimentos_desde]..params[:atendimentos_ate]]) || Atendimento.deste_mes

    @acompanhamentos = Acompanhamento.all

    params[:financeiro_desde] = params[:financeiro_desde]&.to_date || Date.today.beginning_of_month
    params[:financeiro_ate] = params[:financeiro_ate]&.to_date || Date.today.end_of_month
    @recebimentos = Recebimento.where(data: [params[:financeiro_desde].to_date..params[:financeiro_ate].to_date]) || Recebimento.do_mes_atual
    @repasses = ProfissionalFinanceiroRepasse.where(data: [params[:financeiro_desde]..params[:financeiro_ate]]) || ProfissionalFinanceiroRepasse.do_mes_atual

    @finparams = [params[:financeiro_desde], params[:financeiro_ate]]
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
end
