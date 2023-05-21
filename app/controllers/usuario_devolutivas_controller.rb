class UsuarioDevolutivasController < ApplicationController
  before_action :set_usuario_devolutiva, only: %i[ show edit update destroy ]

  # GET /usuario_devolutivas or /usuario_devolutivas.json
  def index
    @usuario_devolutivas = UsuarioDevolutiva.all
  end

  # GET /usuario_devolutivas/1 or /usuario_devolutivas/1.json
  def show
  end

  # GET /usuario_devolutivas/new
  def new
    @usuario_devolutiva = UsuarioDevolutiva.new
  end

  # GET /usuario_devolutivas/1/edit
  def edit
  end

  # POST /usuario_devolutivas or /usuario_devolutivas.json
  def create
    @usuario_devolutiva = UsuarioDevolutiva.new(usuario_devolutiva_params)

    respond_to do |format|
      if @usuario_devolutiva.save
        format.html { redirect_to usuario_devolutiva_url(@usuario_devolutiva), notice: "Usuario devolutiva was successfully created." }
        format.json { render :show, status: :created, location: @usuario_devolutiva }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @usuario_devolutiva.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuario_devolutivas/1 or /usuario_devolutivas/1.json
  def update
    respond_to do |format|
      if @usuario_devolutiva.update(usuario_devolutiva_params)
        format.html { redirect_to usuario_devolutiva_url(@usuario_devolutiva), notice: "Usuario devolutiva was successfully updated." }
        format.json { render :show, status: :ok, location: @usuario_devolutiva }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @usuario_devolutiva.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuario_devolutivas/1 or /usuario_devolutivas/1.json
  def destroy
    @usuario_devolutiva.destroy

    respond_to do |format|
      format.html { redirect_to usuario_devolutivas_url, notice: "Usuario devolutiva was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario_devolutiva
      @usuario_devolutiva = UsuarioDevolutiva.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def usuario_devolutiva_params
      params.require(:usuario_devolutiva).permit(:usuario_id, :usuario_responsavel_id, :profissional_id, :data, :feedback_responsavel, :orientacoes_profissional)
    end
end
