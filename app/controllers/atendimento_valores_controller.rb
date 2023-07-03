class AtendimentoValoresController < ApplicationController
  require 'csv'

  before_action :set_atendimento_valor, only: %i[ show show_pdf edit delete ]

  def index
    @ano = params[:ano] || Date.today.year
    @mes = params[:mes] || Date.today.month

    @ano_mes = "#{@ano}-#{@mes.to_s.rjust(2, "0")}"
    @atendimento_valores = AtendimentoValor.joins(:atendimento).order(data: :asc, horario: :asc).where(atendimento: { data: ["#{@ano}-#{@mes}-01".."#{@ano}-#{@mes}-01".to_date.end_of_month.to_s] })

    respond_to do |format|
      format.html
      format.csv do
        send_data AtendimentoValor.para_csv(@atendimento_valores), filename: "#{Rails.application.class.module_parent_name.to_s}-relatorio-valores-atendimentos_#{@ano}-#{@mes.to_s.rjust(2, "0")}.csv", type: "text/csv"
      end
    end
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
    params.require(:atendimento_valor).permit(:atendimento_id, :valor, :desconto, :taxa_porcentagem_interna, :taxa_porcentagem_externa)
  end
end
