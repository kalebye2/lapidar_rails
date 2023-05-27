class AtendimentosController < ApplicationController
  before_action :set_atendimento, only: %i[ show edit update destroy ]

  def index
  end

  def show
  end

  def new
    @atendimento = Atendimento.new
  end

  def edit
  end

  def create
  end

  def update
    respond_to do |format|
      if @atendimento.update(atendimento_params)
        format.html { redirect_to atendimento_url(@atendimento), notice: "Pessoa was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end


  private

  def set_atendimento
    @atendimento = Atendimento.find(params[:id])
  end

  def atendimento_params
    params.require(:atendimento).permit(:data, :horario, :modalidade_id, :acompanhamento_id, :presenca, :atendimento_tipo_id, :consideracoes)
  end
end
