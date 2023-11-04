class InfantojuvenilAnamneseComunicacao < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :uso_eu
  attribute :entendimento
  attribute :relata_situacoes

  self.primary_key = :infantojuvenil_anamnese_id
end
