class InfantojuvenilAnamneseGestacao < ApplicationRecord
  belongs_to :parto_tipo
  belongs_to :parto_local

  def foi_desejada?
    desejada? ? "Sim" : "Não"
  end
end
