class InfantojuvenilAnamneseSaudeHistorico < ApplicationRecord
  attribute :acompanhamento_medico, ActiveRecord::Type::Integer.new
  attribute :acidente_sofrido, ActiveRecord::Type::Integer.new
end
