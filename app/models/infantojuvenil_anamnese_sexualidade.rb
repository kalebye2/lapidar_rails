class InfantojuvenilAnamneseSexualidade < ApplicationRecord
  attribute :masturba
  belongs_to :infantojuvenil_anamnese

  self.primary_key = :infantojuvenil_anamnese_id

  def masturba?
    masturba.nil? ? nil : masturba > 0
  end
end
