class InfantojuvenilAnamneseGestacao < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :desejada
  attribute :mae_diabetes
  attribute :mae_traumatismo
  attribute :mae_convulsoes

  belongs_to :parto_tipo, optional: true
  belongs_to :parto_local, optional: true

  self.primary_key = :infantojuvenil_anamnese_id

  def foi_desejada?
    desejada > 0 ? "Sim" : "Não"
  end

  def local_do_parto
    parto_local.nil? ? "Sem informação" : parto_local.local
  end

  def tipo_de_parto
    parto_tipo.nil? ? "Sem informação" : parto_tipo.tipo
  end
end
