class AcompanhamentoFinalizacaoMotivosController < ApplicationController
  before_action :set_acompanhamento_finalizacao_motivo, only: %i[ show edit update destroy ]

  before_action :validar_usuario

  # GET /acompanhamento_finalizacao_motivos or /acompanhamento_finalizacao_motivos.json
  def index
    @acompanhamento_finalizacao_motivos = AcompanhamentoFinalizacaoMotivo.all
  end

  # GET /acompanhamento_finalizacao_motivos/1 or /acompanhamento_finalizacao_motivos/1.json
  def show
  end

  # GET /acompanhamento_finalizacao_motivos/new
  def new
    @acompanhamento_finalizacao_motivo = AcompanhamentoFinalizacaoMotivo.new
  end

  # GET /acompanhamento_finalizacao_motivos/1/edit
  def edit
  end

  # POST /acompanhamento_finalizacao_motivos or /acompanhamento_finalizacao_motivos.json
  def create
    @acompanhamento_finalizacao_motivo = AcompanhamentoFinalizacaoMotivo.new(acompanhamento_finalizacao_motivo_params)

    respond_to do |format|
      if @acompanhamento_finalizacao_motivo.save
        format.html { redirect_to acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo), notice: "Acompanhamento finalizacao motivo was successfully created." }
        format.json { render :show, status: :created, location: @acompanhamento_finalizacao_motivo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @acompanhamento_finalizacao_motivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acompanhamento_finalizacao_motivos/1 or /acompanhamento_finalizacao_motivos/1.json
  def update
    respond_to do |format|
      if @acompanhamento_finalizacao_motivo.update(acompanhamento_finalizacao_motivo_params)
        format.html { redirect_to acompanhamento_finalizacao_motivo_url(@acompanhamento_finalizacao_motivo), notice: "Acompanhamento finalizacao motivo was successfully updated." }
        format.json { render :show, status: :ok, location: @acompanhamento_finalizacao_motivo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @acompanhamento_finalizacao_motivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acompanhamento_finalizacao_motivos/1 or /acompanhamento_finalizacao_motivos/1.json
  def destroy
    @acompanhamento_finalizacao_motivo.destroy

    respond_to do |format|
      format.html { redirect_to acompanhamento_finalizacao_motivos_url, notice: "Acompanhamento finalizacao motivo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def validar_usuario
    if usuario_atual.nil? || !checar(usuario_atual.informatica?)
      erro403
      return
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_acompanhamento_finalizacao_motivo
      @acompanhamento_finalizacao_motivo = AcompanhamentoFinalizacaoMotivo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def acompanhamento_finalizacao_motivo_params
      params.require(:acompanhamento_finalizacao_motivo).permit(:motivo)
    end
end
