class InfantojuvenilAnamnesesController < ApplicationController
  before_action :set_infantojuvenil_anamnese, only: %i[ show edit update delete ]
  def index
    @infantojuvenil_anamneses = InfantojuvenilAnamnese.all
  end

  def show
  end

  def new
    @infantojuvenil_anamnese = InfantojuvenilAnamnese.new
  end

  def create
  end

  def edit
  end

  def update
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
end
