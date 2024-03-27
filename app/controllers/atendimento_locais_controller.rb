class AtendimentoLocaisController < ApplicationController
  before_action :set_atendimento_local, only: %i[ show edit update destroy atendimentos ]
  before_action :validar_usuario, only: %i[ show new create edit update destroy ]

  # GET /atendimento_locais or /atendimento_locais.json
  def index
    @atendimento_locais = AtendimentoLocal.all
  end

  # GET /atendimento_locais/1 or /atendimento_locais/1.json
  def show
  end

  # GET /atendimento_locais/new
  def new
    @atendimento_local = AtendimentoLocal.new
  end

  # GET /atendimento_locais/1/edit
  def edit
  end

  # POST /atendimento_locais or /atendimento_locais.json
  def create
    @atendimento_local = AtendimentoLocal.new(atendimento_local_params)

    respond_to do |format|
      if @atendimento_local.save
        format.html { redirect_to atendimento_local_url(@atendimento_local), notice: "Atendimento local was successfully created." }
        format.json { render :show, status: :created, location: @atendimento_local }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento_local.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /atendimento_locais/1 or /atendimento_locais/1.json
  def update
    respond_to do |format|
      if @atendimento_local.update(atendimento_local_params)
        format.html { redirect_to atendimento_local_url(@atendimento_local), notice: "Atendimento local was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento_local }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento_local.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimento_locais/1 or /atendimento_locais/1.json
  def destroy
    @atendimento_local.destroy

    respond_to do |format|
      format.html { redirect_to atendimento_locais_url, notice: "Atendimento local was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def atendimentos
    params[:de] ||= Date.today.beginning_of_month
    params[:ate] ||= Date.today.end_of_month
    @de = params[:de].to_date
    @ate = params[:ate].to_date
    @atendimentos = @atendimento_local.atendimentos.do_periodo(@de..@ate)
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def validar_usuario
    if usuario_atual.nil? || !usuario_atual.secretaria?
      erro403
      return
    end
  end

  def set_atendimento_local
    @atendimento_local = AtendimentoLocal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def atendimento_local_params
    params.require(:atendimento_local).permit(:atendimento_local_tipo_id, :descricao, :pais_id, :endereco_estado, :endereco_cidade, :endereco_bairro, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :latitude, :longitude)
  end
end
