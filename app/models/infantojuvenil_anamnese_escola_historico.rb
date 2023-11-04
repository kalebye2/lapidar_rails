class InfantojuvenilAnamneseEscolaHistorico < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  belongs_to :escola_tipo, optional: true

  self.primary_key = :infantojuvenil_anamnese_id

  def tipo_de_escola
    escola_tipo.nil? ? "Sem informação" : escola_tipo.tipo
  end
end
