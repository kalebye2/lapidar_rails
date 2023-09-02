class InfantojuvenilAnamneseEscolaHistorico < ApplicationRecord
  belongs_to :escola_tipo, optional: true

  def tipo_de_escola
    escola_tipo.nil? ? "Sem informação" : escola_tipo.tipo
  end
end
