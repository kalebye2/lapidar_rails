class AtendimentoTiposController < ApplicationController
  before_action :set_atendimento_tipo, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /atendimento_tipos or /atendimento_tipos.json
  def index
    @atendimento_tipos = AtendimentoTipo.all
  end

  # GET /atendimento_tipos/1 or /atendimento_tipos/1.json
  def show
  end

  # GET /atendimento_tipos/new
  def new
    @atendimento_tipo = AtendimentoTipo.new
  end

  # GET /atendimento_tipos/1/edit
  def edit
  end

  # POST /atendimento_tipos or /atendimento_tipos.json
  def create
    @atendimento_tipo = AtendimentoTipo.new(atendimento_tipo_params)

    respond_to do |format|
      if @atendimento_tipo.save
        format.html { redirect_to atendimento_tipo_url(@atendimento_tipo), notice: "Atendimento tipo was successfully created." }
        format.json { render :show, status: :created, location: @atendimento_tipo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento_tipo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /atendimento_tipos/1 or /atendimento_tipos/1.json
  def update
    respond_to do |format|
      if @atendimento_tipo.update(atendimento_tipo_params)
        format.html { redirect_to atendimento_tipo_url(@atendimento_tipo), notice: "Atendimento tipo was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento_tipo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento_tipo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimento_tipos/1 or /atendimento_tipos/1.json
  def destroy
    @atendimento_tipo.destroy

    respond_to do |format|
      format.html { redirect_to atendimento_tipos_url, notice: "Atendimento tipo was successfully destroyed." }
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
    def set_atendimento_tipo
      @atendimento_tipo = AtendimentoTipo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def atendimento_tipo_params
      params.require(:atendimento_tipo).permit(:tipo, :profissional_funcao_id)
    end
end
