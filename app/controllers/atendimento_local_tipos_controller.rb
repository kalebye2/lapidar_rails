class AtendimentoLocalTiposController < ApplicationController
  before_action :set_atendimento_local_tipo, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /atendimento_local_tipos or /atendimento_local_tipos.json
  def index
    @atendimento_local_tipos = AtendimentoLocalTipo.all
  end

  # GET /atendimento_local_tipos/1 or /atendimento_local_tipos/1.json
  def show
  end

  # GET /atendimento_local_tipos/new
  def new
    @atendimento_local_tipo = AtendimentoLocalTipo.new
  end

  # GET /atendimento_local_tipos/1/edit
  def edit
  end

  # POST /atendimento_local_tipos or /atendimento_local_tipos.json
  def create
    @atendimento_local_tipo = AtendimentoLocalTipo.new(atendimento_local_tipo_params)

    respond_to do |format|
      if @atendimento_local_tipo.save
        format.html { redirect_to atendimento_local_tipo_url(@atendimento_local_tipo), notice: "Atendimento local tipo was successfully created." }
        format.json { render :show, status: :created, location: @atendimento_local_tipo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento_local_tipo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /atendimento_local_tipos/1 or /atendimento_local_tipos/1.json
  def update
    respond_to do |format|
      if @atendimento_local_tipo.update(atendimento_local_tipo_params)
        format.html { redirect_to atendimento_local_tipo_url(@atendimento_local_tipo), notice: "Atendimento local tipo was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento_local_tipo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento_local_tipo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimento_local_tipos/1 or /atendimento_local_tipos/1.json
  def destroy
    @atendimento_local_tipo.destroy

    respond_to do |format|
      format.html { redirect_to atendimento_local_tipos_url, notice: "Atendimento local tipo was successfully destroyed." }
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
    def set_atendimento_local_tipo
      @atendimento_local_tipo = AtendimentoLocalTipo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def atendimento_local_tipo_params
      params.require(:atendimento_local_tipo).permit(:tipo)
    end
end
