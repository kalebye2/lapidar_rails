class AcompanhamentoReajusteMotivosController < ApplicationController
  before_action :set_acompanhamento_reajuste_motivo, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /acompanhamento_reajuste_motivos or /acompanhamento_reajuste_motivos.json
  def index
    @acompanhamento_reajuste_motivos = AcompanhamentoReajusteMotivo.all
  end

  # GET /acompanhamento_reajuste_motivos/1 or /acompanhamento_reajuste_motivos/1.json
  def show
  end

  # GET /acompanhamento_reajuste_motivos/new
  def new
    @acompanhamento_reajuste_motivo = AcompanhamentoReajusteMotivo.new
  end

  # GET /acompanhamento_reajuste_motivos/1/edit
  def edit
  end

  # POST /acompanhamento_reajuste_motivos or /acompanhamento_reajuste_motivos.json
  def create
    @acompanhamento_reajuste_motivo = AcompanhamentoReajusteMotivo.new(acompanhamento_reajuste_motivo_params)

    respond_to do |format|
      if @acompanhamento_reajuste_motivo.save
        format.html { redirect_to acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo), notice: "Acompanhamento reajuste motivo was successfully created." }
        format.json { render :show, status: :created, location: @acompanhamento_reajuste_motivo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @acompanhamento_reajuste_motivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acompanhamento_reajuste_motivos/1 or /acompanhamento_reajuste_motivos/1.json
  def update
    respond_to do |format|
      if @acompanhamento_reajuste_motivo.update(acompanhamento_reajuste_motivo_params)
        format.html { redirect_to acompanhamento_reajuste_motivo_url(@acompanhamento_reajuste_motivo), notice: "Acompanhamento reajuste motivo was successfully updated." }
        format.json { render :show, status: :ok, location: @acompanhamento_reajuste_motivo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @acompanhamento_reajuste_motivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acompanhamento_reajuste_motivos/1 or /acompanhamento_reajuste_motivos/1.json
  def destroy
    @acompanhamento_reajuste_motivo.destroy

    respond_to do |format|
      format.html { redirect_to acompanhamento_reajuste_motivos_url, notice: "Acompanhamento reajuste motivo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  
  def validar_usuario
    if usuario_atual.nil? || (!usuario_atual.secretaria? || !usuario_atual.informatica?)
      erro403
      return
    end
  end

    def set_acompanhamento_reajuste_motivo
      @acompanhamento_reajuste_motivo = AcompanhamentoReajusteMotivo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def acompanhamento_reajuste_motivo_params
      params.fetch(:acompanhamento_reajuste_motivo, {})
    end
end
