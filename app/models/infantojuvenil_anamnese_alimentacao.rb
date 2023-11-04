class InfantojuvenilAnamneseAlimentacao < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :succao_boa
  attribute :usou_mamadeira
  attribute :rejeicao
  attribute :precisa_ajuda
  self.primary_key = :infantojuvenil_anamnese_id
end
