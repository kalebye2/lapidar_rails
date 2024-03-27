class CivilEstadosController < ApplicationController
  before_action :set_civil_estado, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /civil_estados or /civil_estados.json
  def index
    @civil_estados = CivilEstado.all
  end

  # GET /civil_estados/1 or /civil_estados/1.json
  def show
  end

  # GET /civil_estados/new
  def new
    @civil_estado = CivilEstado.new
  end

  # GET /civil_estados/1/edit
  def edit
  end

  # POST /civil_estados or /civil_estados.json
  def create
    @civil_estado = CivilEstado.new(civil_estado_params)

    respond_to do |format|
      if @civil_estado.save
        format.html { redirect_to civil_estado_url(@civil_estado), notice: "Civil estado was successfully created." }
        format.json { render :show, status: :created, location: @civil_estado }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @civil_estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /civil_estados/1 or /civil_estados/1.json
  def update
    respond_to do |format|
      if @civil_estado.update(civil_estado_params)
        format.html { redirect_to civil_estado_url(@civil_estado), notice: "Civil estado was successfully updated." }
        format.json { render :show, status: :ok, location: @civil_estado }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @civil_estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /civil_estados/1 or /civil_estados/1.json
  def destroy
    @civil_estado.destroy

    respond_to do |format|
      format.html { redirect_to civil_estados_url, notice: "Civil estado was successfully destroyed." }
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
  def set_civil_estado
    @civil_estado = CivilEstado.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def civil_estado_params
    params.require(:civil_estado).permit(:estado)
  end
end
