class AdultoAnamnesesController < ApplicationController
  before_action :set_adulto_anamnese, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /adulto_anamneses or /adulto_anamneses.json
  def index
    @adulto_anamneses = AdultoAnamnese.all
  end

  # GET /adulto_anamneses/1 or /adulto_anamneses/1.json
  def show
  end

  # GET /adulto_anamneses/new
  def new
    @adulto_anamnese = AdultoAnamnese.new
  end

  # GET /adulto_anamneses/1/edit
  def edit
  end

  # POST /adulto_anamneses or /adulto_anamneses.json
  def create
    @adulto_anamnese = AdultoAnamnese.new(adulto_anamnese_params)

    respond_to do |format|
      if @adulto_anamnese.save
        format.html { redirect_to adulto_anamnese_url(@adulto_anamnese), notice: " adulto anamnese was successfully created." }
        format.json { render :show, status: :created, location: @adulto_anamnese }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @adulto_anamnese.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adulto_anamneses/1 or /adulto_anamneses/1.json
  def update
    respond_to do |format|
      if @adulto_anamnese.update(adulto_anamnese_params)
        format.html { redirect_to adulto_anamnese_url(@adulto_anamnese), notice: " adulto anamnese was successfully updated." }
        format.json { render :show, status: :ok, location: @adulto_anamnese }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @adulto_anamnese.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adulto_anamneses/1 or /adulto_anamneses/1.json
  def destroy
    @adulto_anamnese.destroy

    respond_to do |format|
      format.html { redirect_to adulto_anamneses_url, notice: " adulto anamnese was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

  def validar_usuario
    if usuario_atual.nil? || !(usuario_atual.secretaria? || usuario_atual.corpo_clinico?)
      erro403
      return
    end
  end

  def set_adulto_anamnese
    @adulto_anamnese = AdultoAnamnese.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def adulto_anamnese_params
    params.require(:adulto_anamnese).permit(:atendimento_id, :escolaridade_anos, :historico_profissional, :aspectos_psicoemocionais, :historico_ocupacional, :historico_medico, :aspectos_psicossociais, :antecedentes_familiares, :comorbidades, :desenvolvimento_neuropsicomotor, :medicacoes_em_uso, :uso_drogas_ilicitas, :autonomia_atividades, :alimentacao, :sono, :habilidades_afetadas, :quem_encaminhou, :motivo_encaminhamento, :diagnostico_preliminar, :plano_tratamento, :prognostico)
  end
end
