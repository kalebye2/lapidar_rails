class AdultoAnamnesesController < ApplicationController
  before_action :set_neuropsicologico_adulto_anamnese, only: %i[ show edit update destroy ]
  before_action :validar_usuario

  # GET /neuropsicologico_adulto_anamneses or /neuropsicologico_adulto_anamneses.json
  def index
    @neuropsicologico_adulto_anamneses = NeuropsicologicoAdultoAnamnese.all
  end

  # GET /neuropsicologico_adulto_anamneses/1 or /neuropsicologico_adulto_anamneses/1.json
  def show
  end

  # GET /neuropsicologico_adulto_anamneses/new
  def new
    @neuropsicologico_adulto_anamnese = NeuropsicologicoAdultoAnamnese.new
  end

  # GET /neuropsicologico_adulto_anamneses/1/edit
  def edit
  end

  # POST /neuropsicologico_adulto_anamneses or /neuropsicologico_adulto_anamneses.json
  def create
    @neuropsicologico_adulto_anamnese = NeuropsicologicoAdultoAnamnese.new(neuropsicologico_adulto_anamnese_params)

    respond_to do |format|
      if @neuropsicologico_adulto_anamnese.save
        format.html { redirect_to neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese), notice: "Neuropsicologico adulto anamnese was successfully created." }
        format.json { render :show, status: :created, location: @neuropsicologico_adulto_anamnese }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @neuropsicologico_adulto_anamnese.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /neuropsicologico_adulto_anamneses/1 or /neuropsicologico_adulto_anamneses/1.json
  def update
    respond_to do |format|
      if @neuropsicologico_adulto_anamnese.update(neuropsicologico_adulto_anamnese_params)
        format.html { redirect_to neuropsicologico_adulto_anamnese_url(@neuropsicologico_adulto_anamnese), notice: "Neuropsicologico adulto anamnese was successfully updated." }
        format.json { render :show, status: :ok, location: @neuropsicologico_adulto_anamnese }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @neuropsicologico_adulto_anamnese.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /neuropsicologico_adulto_anamneses/1 or /neuropsicologico_adulto_anamneses/1.json
  def destroy
    @neuropsicologico_adulto_anamnese.destroy

    respond_to do |format|
      format.html { redirect_to neuropsicologico_adulto_anamneses_url, notice: "Neuropsicologico adulto anamnese was successfully destroyed." }
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

  def set_neuropsicologico_adulto_anamnese
    @neuropsicologico_adulto_anamnese = NeuropsicologicoAdultoAnamnese.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def neuropsicologico_adulto_anamnese_params
    params.require(:neuropsicologico_adulto_anamnese).permit(:atendimento_id, :escolaridade_anos, :historico_profissional, :aspectos_psicoemocionais, :historico_ocupacional, :historico_medico, :aspectos_psicossociais, :antecedentes_familiares, :comorbidades, :desenvolvimento_neuropsicomotor, :medicacoes_em_uso, :uso_drogas_ilicitas, :autonomia_atividades, :alimentacao, :sono, :habilidades_afetadas, :quem_encaminhou, :motivo_encaminhamento, :diagnostico_preliminar, :plano_tratamento, :prognostico)
  end
end
