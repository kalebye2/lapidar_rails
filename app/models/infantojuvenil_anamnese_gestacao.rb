class InfantojuvenilAnamneseGestacao < ApplicationRecord
  attribute :desejada, ActiveRecord::Type::Integer.new
  attribute :mae_diabetes, ActiveRecord::Type::Integer.new
  attribute :mae_traumatismo, ActiveRecord::Type::Integer.new
  attribute :mae_convulsoes, ActiveRecord::Type::Integer.new

  belongs_to :parto_tipo, optional: true
  belongs_to :parto_local, optional: true

  def foi_desejada?
    desejada? ? "Sim" : "Não"
  end
end
