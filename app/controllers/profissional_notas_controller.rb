class ProfissionalNotasController < ApplicationController
  before_action :set_profissional_nota, only: %i[ show edit update destroy ]

  # GET /profissional_notas or /profissional_notas.json
  def index
    @profissional_notas = ProfissionalNota.all
  end

  # GET /profissional_notas/1 or /profissional_notas/1.json
  def show
  end

  # GET /profissional_notas/new
  def new
    @profissional_nota = ProfissionalNota.new
  end

  # GET /profissional_notas/1/edit
  def edit
  end

  # POST /profissional_notas or /profissional_notas.json
  def create
    @profissional_nota = ProfissionalNota.new(profissional_nota_params)

    respond_to do |format|
      if @profissional_nota.save
        format.html { redirect_to profissional_nota_url(@profissional_nota), notice: "Profissional nota was successfully created." }
        format.json { render :show, status: :created, location: @profissional_nota }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profissional_nota.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profissional_notas/1 or /profissional_notas/1.json
  def update
    respond_to do |format|
      if @profissional_nota.update(profissional_nota_params)
        format.html { redirect_to profissional_nota_url(@profissional_nota), notice: "Profissional nota was successfully updated." }
        format.json { render :show, status: :ok, location: @profissional_nota }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profissional_nota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profissional_notas/1 or /profissional_notas/1.json
  def destroy
    @profissional_nota.destroy

    respond_to do |format|
      format.html { redirect_to profissional_notas_url, notice: "Profissional nota was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profissional_nota
      @profissional_nota = ProfissionalNota.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profissional_nota_params
      params.require(:profissional_nota).permit(:profissional_id, :nota, :data, :hora, :data_lembrar, :hora_lembrar)
    end
end
