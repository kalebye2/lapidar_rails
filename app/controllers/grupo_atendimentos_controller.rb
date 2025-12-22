class GrupoAtendimentosController < ApplicationController
  before_action :set_grupo_atendimento, only: %i[ show edit update destroy ]

  # GET /grupo_atendimentos or /grupo_atendimentos.json
  def index
    @grupo_atendimentos = GrupoAtendimento.all
  end

  # GET /grupo_atendimentos/1 or /grupo_atendimentos/1.json
  def show
  end

  # GET /grupo_atendimentos/new
  def new
    @grupo_atendimento = GrupoAtendimento.new
  end

  # GET /grupo_atendimentos/1/edit
  def edit
  end

  # POST /grupo_atendimentos or /grupo_atendimentos.json
  def create
    @grupo_atendimento = GrupoAtendimento.new(grupo_atendimento_params)

    respond_to do |format|
      if @grupo_atendimento.save
        format.html { redirect_to grupo_atendimento_url(@grupo_atendimento), notice: "Grupo atendimento was successfully created." }
        format.json { render :show, status: :created, location: @grupo_atendimento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grupo_atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grupo_atendimentos/1 or /grupo_atendimentos/1.json
  def update
    respond_to do |format|
      if @grupo_atendimento.update(grupo_atendimento_params)
        format.html { redirect_to grupo_atendimento_url(@grupo_atendimento), notice: "Grupo atendimento was successfully updated." }
        format.json { render :show, status: :ok, location: @grupo_atendimento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grupo_atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grupo_atendimentos/1 or /grupo_atendimentos/1.json
  def destroy
    @grupo_atendimento.destroy

    respond_to do |format|
      format.html { redirect_to grupo_atendimentos_url, notice: "Grupo atendimento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grupo_atendimento
      @grupo_atendimento = GrupoAtendimento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grupo_atendimento_params
      params.require(:grupo_atendimento).permit(:grupo_id, :data, :horario, :horario_fim, :modalidade_id, :atendimento_local_id, :anotacoes, :avancos, :limitacoes)
    end
end
