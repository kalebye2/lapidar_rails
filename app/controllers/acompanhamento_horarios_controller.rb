class AcompanhamentoHorariosController < ApplicationController
  before_action :set_acompanhamento, only: %i[ show edit update destroy ]

  def index
    @acompanhamento_horarios = AcompanhamentoHorario.order(semana_dia_id: :asc, horario: :asc)
  end

  def show
  end

  def new
    if params[:ajax].present? && params[:ajax]
      if params[:acompanhamento].present? && !params[:acompanhamento].nil?
        render partial: "form_ajax", locals: { acompanhamento_horario: AcompanhamentoHorario.new(acompanhamento: Acompanhamento.find(params[:acompanhamento])) }
      else
        render partial: "form_ajax", locals: { acompanhamento_horario: AcompanhamentoHorario.new }
      end
    end
  end

  def create
    @acompanhamento_horario = AcompanhamentoHorario.new(acompanhamento_horario_params)
    respond_to do |format|
      if @acompanhamento_horario.save
        format.html do
          if params[:ajax].present? && params[:ajax]
            render partial: "resumo_acompanhamento", locals: { acompanhamento: @acompanhamento_horario.acompanhamento }
          end
        end
      else
        format.html do
          if params[:ajax].present? && params[:ajax]
            render partial: "resumo_acompanhamento_form", locals: { acompanhamento: @acompanhamento_horario.acompanhamento }
          end
        end
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_acompanhamento
    @acompanhamento = Acompanhamento.find(params[:id])
  end

  def acompanhamento_horario_params
    params.require(:acompanhamento_horario).permit(:acompanhamento_id, :horario, :horario_fim, :semana_dia_id)
  end
end
