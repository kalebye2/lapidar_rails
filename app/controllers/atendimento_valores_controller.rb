class AtendimentoValoresController < ApplicationController
  before_action :set_atendimento_valor, only: %i[ show show_pdf edit delete ]

  def index
    @atendimento_valores = AtendimentoValor.joins("JOIN atendimentos ON atendimento_valores.atendimento_id = atendimentos.id").order(data: :desc, horario: :desc).where("data < CURRENT_DATE OR (data = CURRENT_DATE AND HOUR(horario) < HOUR(CURRENT_TIME))").all
  end

  def index_pdf
  end

  def show
  end

  def show_pdf
  end

  def new
    @atendimento_valor = AtendimentoValor.new
  end

  def create
    @atendimento_valor = AtendimentoValor.new(atendimento_valor_params)

    respond_to do |format|
      if @atendimento_valor.save
        format.html { redirect_to atendimento_valor_url(@atendimento_valor), notice: "pessoa devolutiva was successfully created." }
        format.json { render :show, status: :created, location: @atendimento_valor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento_valor.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @atendimento_valor.update(atendimento_valor_params)
        format.html { redirect_to atendimento_valor_url(@atendimento_valor), notice: "pessoa devolutiva was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento_valor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento_valor.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  private

  def set_atendimento_valor
    @atendimento_valor = AtendimentoValor.find(params[:id])
  end

  def atendimento_valor_params
    params.require(:atendimento_valor).permit(:atendimento_id, :valor, :desconto, :taxa_porcentagem)
  end

end
