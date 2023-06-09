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
    @atendimento = Atendimento.new(atendimento_params)

    respond_to do |format|
      if @atendimento.save
        format.html { redirect_to atendimento_url(@atendimento), notice: "Atendimento registrado com sucesso!" }
        format.json { render :show, status: :created, location: @atendimento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @atendimento.update(atendimento_params)
        format.html { redirect_to atendimento_url(@atendimento), notice: "Atendimento atualizado com sucesso." }
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
    params.require(:atendimento).permit(:data, :horario, :modalidade_id, :acompanhamento_id, :presenca, :atendimento_tipo_id, :consideracoes, :remarcado, :atendimento_local_id, :reagendado, atendimento_valor_attributes: [:atendimento_id, :valor, :desconto, :taxa_porcentagem])
  end
end
