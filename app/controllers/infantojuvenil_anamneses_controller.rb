class InfantojuvenilAnamnesesController < ApplicationController
  before_action :set_infantojuvenil_anamnese, only: %i[ show edit update delete ]
  def index
    @infantojuvenil_anamneses = InfantojuvenilAnamnese.all
  end

  def show
    respond_to do |format|
      format.html
      format.md do
        response.headers['Content-Type'] = "text/markdown"
        response.headers['Content-Disposition'] = "attachment; filename=anamnese-infantojuvenil_#{@infantojuvenil_anamnese.pessoa.nome_completo.parameterize}_#{@infantojuvenil_anamnese.atendimento.data}.md"
      end
    end
  end

  def new
    @infantojuvenil_anamnese = InfantojuvenilAnamnese.new
  end

  def create
    @infantojuvenil_anamnese.criar_anamnese_completa
  end

  def edit
  end

  def update
    print infantojuvenil_anamnese_params
    @infantojuvenil_anamnese.update(infantojuvenil_anamnese_params)
    redirect_to infantojuvenil_anamneses_path
  end

  def delete
  end

  private

  def set_infantojuvenil_anamnese
    @infantojuvenil_anamnese = InfantojuvenilAnamnese.find(params[:id])
    @alimentacao = @infantojuvenil_anamnese.alimentacao
    @sexualidade = @infantojuvenil_anamnese.sexualidade
    @psicomotricidade = @infantojuvenil_anamnese.psicomotricidade
    @sono = @infantojuvenil_anamnese.sono
    @escola_historico = @infantojuvenil_anamnese.escola_historico
    @socioafetividade = @infantojuvenil_anamnese.socioafetividade
    @saude_historico = @infantojuvenil_anamnese.saude_historico
    @comunicacao = @infantojuvenil_anamnese.comunicacao
    @familia_historico = @infantojuvenil_anamnese.familia_historico
    @gestacao = @infantojuvenil_anamnese.gestacao
    @manipulacao = @infantojuvenil_anamnese.manipulacao
  end

  def infantojuvenil_anamnese_params
    params.require(:infantojuvenil_anamnese).permit(:atendimento_id,
      :motivo_consulta,
      :diagnostico_preliminar,
      :plano_tratamento,
      :prognostico,
      infantojuvenil_anamnese_gestacao: [
        :mae_diabetes
      ])
  end
end
