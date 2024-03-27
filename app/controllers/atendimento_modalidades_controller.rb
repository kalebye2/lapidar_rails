class AtendimentoModalidadesController < ApplicationController
  before_action :set_atendimento_modalidade, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /atendimento_modalidades or /atendimento_modalidades.json
  def index
    @atendimento_modalidades = AtendimentoModalidade.all
  end

  # GET /atendimento_modalidades/1 or /atendimento_modalidades/1.json
  def show
  end

  # GET /atendimento_modalidades/new
  def new
    @atendimento_modalidade = AtendimentoModalidade.new
  end

  # GET /atendimento_modalidades/1/edit
  def edit
  end

  # POST /atendimento_modalidades or /atendimento_modalidades.json
  def create
    @atendimento_modalidade = AtendimentoModalidade.new(atendimento_modalidade_params)

    respond_to do |format|
      if @atendimento_modalidade.save
        format.html { redirect_to atendimento_modalidade_url(@atendimento_modalidade), notice: "Atendimento modalidade was successfully created." }
        format.json { render :show, status: :created, location: @atendimento_modalidade }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento_modalidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /atendimento_modalidades/1 or /atendimento_modalidades/1.json
  def update
    respond_to do |format|
      if @atendimento_modalidade.update(atendimento_modalidade_params)
        format.html { redirect_to atendimento_modalidade_url(@atendimento_modalidade), notice: "Atendimento modalidade was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento_modalidade }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento_modalidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimento_modalidades/1 or /atendimento_modalidades/1.json
  def destroy
    @atendimento_modalidade.destroy

    respond_to do |format|
      format.html { redirect_to atendimento_modalidades_url, notice: "Atendimento modalidade was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def validar_usuario
    if !usuario_logado || !checar(usuario_atual.informatica?)
      erro403
      return
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_atendimento_modalidade
      @atendimento_modalidade = AtendimentoModalidade.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def atendimento_modalidade_params
      params.require(:atendimento_modalidade).permit(:modalidade)
    end
end
