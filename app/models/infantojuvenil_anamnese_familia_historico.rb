class InfantojuvenilAnamneseFamiliaHistorico < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  
  attribute :ambiente_familiar_usuario_consciente_situacao_economica

  self.primary_key = :infantojuvenil_anamnese_id
end
