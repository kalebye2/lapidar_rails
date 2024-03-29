class InfantojuvenilAnamnesePsicomotricidade < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :canhoto
  attribute :precisa_ajuda_banheiro
  attribute :toma_banho_sozinho
  attribute :veste_sozinho
  attribute :caia_muito
  attribute :conhecimento_lateralidade

  self.primary_key = :infantojuvenil_anamnese_id

  def canhoto?
    canhoto.nil? ? nil : canhoto > 0
  end

  def precisa_ajuda_banheiro?
    precisa_ajuda_banheiro.nil? ? nil : precisa_ajuda_banheiro > 0
  end

  def toma_banho_sozinho?
    toma_banho_sozinho.nil? ? nil : toma_banho_sozinho > 0
  end

  def veste_sozinho?
    veste_sozinho.nil? ? nil : veste_sozinho > 0
  end

  def caia_muito?
    caia_muito.nil? ? nil : caia_muito > 0
  end

  def conhecimento_lateralidade?
    conhecimento_lateralidade.nil? ? nil : conhecimento_lateralidade > 0
  end

end
