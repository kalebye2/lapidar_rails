class InstrumentosController < ApplicationController
  before_action :set_instrumento, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /instrumentos or /instrumentos.json
  def index
    @instrumentos = Instrumento.all

    if params[:nome].present?
      @instrumentos = @instrumentos.por_nome(params[:nome])
    end

    if params[:indicacao].present?
      @instrumentos = @instrumentos.por_indicacao(params[:indicacao])
    end
  end

  # GET /instrumentos/1 or /instrumentos/1.json
  def show
  end

  # GET /instrumentos/new
  def new
    @instrumento = Instrumento.new
  end

  # GET /instrumentos/1/edit
  def edit
  end

  # POST /instrumentos or /instrumentos.json
  def create
    @instrumento = Instrumento.new(instrumento_params)

    respond_to do |format|
      if @instrumento.save
        format.html { redirect_to instrumento_url(@instrumento), notice: "Instrumento was successfully created." }
        format.json { render :show, status: :created, location: @instrumento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instrumento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instrumentos/1 or /instrumentos/1.json
  def update
    respond_to do |format|
      if @instrumento.update(instrumento_params)
        format.html { redirect_to instrumento_url(@instrumento), notice: "Instrumento was successfully updated." }
        format.json { render :show, status: :ok, location: @instrumento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instrumento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instrumentos/1 or /instrumentos/1.json
  def destroy
    @instrumento.destroy

    respond_to do |format|
      format.html { redirect_to instrumentos_url, notice: "Instrumento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instrumento
      @instrumento = Instrumento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def instrumento_params
      params.require(:instrumento).permit(:nome, :instrumento_tipo_id, :exclusivo_psicologo, :faixa_etaria_meses_inicio, :faixa_etaria_meses_final, :objetivo, :cronometrado, :material, :aplicacao, :indicacao, :particularidades, :tem_na_clinica)
    end

    def validar_usuario
      if usuario_atual.nil? || !(usuario_atual.secretaria? || usuario_atual.corpo_clinico?)
        erro403
      end
    end
end
