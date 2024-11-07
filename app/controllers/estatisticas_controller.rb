class EstatisticasController < ApplicationController
  require 'csv'
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

    nome_documento = "#{nome_do_site&.parameterize}_estatisticas_#{@de}-#{@ate}"

    respond_to do |format|
      format.html

      format.csv do
        final = CSV.generate do |csv|
          csv << [
            "IMPLEMENTAÇÃO A REALIZAR",
          ]
        end

        send_data final, filename: "#{nome_documento}.csv"
      end
    end
  end

  def clinica
    @atendimentos = Atendimento.em_ordem.ate_hoje
    @contagem_atendimentos_por_profissional = @atendimentos.contagem_por_profissional
    @contagem_atendimentos_por_local = @atendimentos.contagem_por_local
  end

  def acompanhamentos
  end

  def atendimentos
    set_de_ate Date.current.beginning_of_month, Date.current.end_of_month
    @atendimentos = Atendimento.do_periodo @de..@ate
  end

  def profissionais
  end

  def pacientes
  end

  def instrumentos
    set_de_ate Date.current.beginning_of_month, Date.current.end_of_month
  end

  def financeiro
    de_ate_params

    @recebimentos = Recebimento.do_periodo(@de..@ate)
    @atendimento_valores = AtendimentoValor.do_periodo(@de..@ate)
  end

  private

  def validar_usuario
    if !usuario_atual
      erro403
      return
    end
  end
end
