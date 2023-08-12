class InfantojuvenilAnamneseSexualidade < ApplicationRecord
  attribute :masturba, ActiveRecord::Type::Integer.new

  def masturba?
    masturba.nil? ? nil : masturba > 0
  end
end
