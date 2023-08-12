class InfantojuvenilAnamneseComunicacao < ApplicationRecord
  attribute :uso_eu, ActiveRecord::Type::Integer.new
  attribute :entendimento, ActiveRecord::Type::Integer.new
  attribute :relata_situacoes, ActiveRecord::Type::Integer.new
end
