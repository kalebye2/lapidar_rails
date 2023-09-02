class InfantojuvenilAnamneseSexualidade < ApplicationRecord
  attribute :masturba

  def masturba?
    masturba.nil? ? nil : masturba > 0
  end
end
