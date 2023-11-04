class InfantojuvenilAnamneseSaudeHistorico < ApplicationRecord
  belongs_to :infantojuvenil_anamnese

  attribute :acompanhamento_medico
  attribute :acidente_sofrido

  self.primary_key = :infantojuvenil_anamnese_id
end
