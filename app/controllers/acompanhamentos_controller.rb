class AcompanhamentosController < ApplicationController
  before_action :set_acompanhamento, only: %i[ show edit update destroy ]

  def index
    @acompanhamentos = Acompanhamento.all.order(data_inicio: :desc)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end


  private

  def set_acompanhamento
    @acompanhamento = Acompanhamento.find(params[:id])
  end

  def acompanhamento_params
    params.require(:acompanhamento).permit(:usuario_id, :profissional_id, :plataforma_id, :motivo, :data_inicio, :data_final, :finalizacao_motivo_id, :valor_contrato, :sessoes_contrato, :valor_atual, :sessoes_atuais, :acompanhamento_tipo_id, :menor_de_idade, :usuario_responsavel_id, :sessoes_previstas)
  end

end
