class InfantojuvenilAnamneseAlimentacao < ApplicationRecord
  attribute :succao_boa, ActiveRecord::Type::Integer.new
  attribute :usou_mamadeira, ActiveRecord::Type::Integer.new
  attribute :rejeicao, ActiveRecord::Type::Integer.new
  attribute :precisa_ajuda, ActiveRecord::Type::Integer.new
end
