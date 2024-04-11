class AcompanhamentoHorariosController < ApplicationController
  before_action :set_acompanhamento, except: %i[ index ]

  def index
    @acompanhamento_horarios = AcompanhamentoHorario.order(semana_dia_id: :asc, horario: :asc)
  end

  def show
  end

  def new
    if hx_request?
      if params[:id].present? && !params[:id].nil?
        render partial: "form_ajax", locals: { acompanhamento_horario: AcompanhamentoHorario.new(acompanhamento: Acompanhamento.find(params[:id])), acompanhamento: @acompanhamento }
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
          if hx_request?
            render partial: "resumo_acompanhamento", locals: { acompanhamento: @acompanhamento_horario.acompanhamento }
          end
        end
      else
        format.html do
          if hx_request?
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
    @acompanhamento_horario = AcompanhamentoHorario.find_by(acompanhamento: @acompanhamento, horario: params[:horario]&.to_time, horario_fim: params[:horario_fim]&.to_time, semana_dia_id: params[:semana_dia_id])
    @acompanhamento_horario.destroy
    render partial: 'acompanhamento_horarios/resumo_acompanhamento', locals: { acompanhamento: @acompanhamento }
  end

  def show_botao_novo_horario
    render partial: 'acompanhamento_horarios/registrar_novo_horario_button', locals: {acompanhamento: @acompanhamento}
  end

  private

  def validar_usuario
    if usuario_atual.nil? || !usuario_atual.secretaria? || usuario_atual.profissional != @acompanhamento_horario&.profissional
      erro403
    end
  end

  def set_acompanhamento
    @acompanhamento = Acompanhamento.find(params[:id])
  end

  def acompanhamento_horario_params
    params.require(:acompanhamento_horario).permit(:acompanhamento_id, :horario, :horario_fim, :semana_dia_id)
  end
end
