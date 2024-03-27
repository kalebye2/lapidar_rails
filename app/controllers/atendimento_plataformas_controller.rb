class AtendimentoPlataformasController < ApplicationController
  before_action :set_atendimento_plataforma, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /atendimento_plataformas or /atendimento_plataformas.json
  def index
    @atendimento_plataformas = AtendimentoPlataforma.all
  end

  # GET /atendimento_plataformas/1 or /atendimento_plataformas/1.json
  def show
  end

  # GET /atendimento_plataformas/new
  def new
    @atendimento_plataforma = AtendimentoPlataforma.new
  end

  # GET /atendimento_plataformas/1/edit
  def edit
  end

  # POST /atendimento_plataformas or /atendimento_plataformas.json
  def create
    @atendimento_plataforma = AtendimentoPlataforma.new(atendimento_plataforma_params)

    respond_to do |format|
      if @atendimento_plataforma.save
        format.html { redirect_to atendimento_plataforma_url(@atendimento_plataforma), notice: "Atendimento plataforma was successfully created." }
        format.json { render :show, status: :created, location: @atendimento_plataforma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento_plataforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /atendimento_plataformas/1 or /atendimento_plataformas/1.json
  def update
    respond_to do |format|
      if @atendimento_plataforma.update(atendimento_plataforma_params)
        format.html { redirect_to atendimento_plataforma_url(@atendimento_plataforma), notice: "Atendimento plataforma was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento_plataforma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento_plataforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimento_plataformas/1 or /atendimento_plataformas/1.json
  def destroy
    @atendimento_plataforma.destroy

    respond_to do |format|
      format.html { redirect_to atendimento_plataformas_url, notice: "Atendimento plataforma was successfully destroyed." }
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
    def set_atendimento_plataforma
      @atendimento_plataforma = AtendimentoPlataforma.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def atendimento_plataforma_params
      params.require(:atendimento_plataforma).permit(:nome, :site, :descricao, :taxa_fixa, :taxa_atendimento)
    end
end
