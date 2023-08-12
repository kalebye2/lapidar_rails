class InfantojuvenilAnamneseManipulacao < ApplicationRecord
  attribute :chupeta_usou, ActiveRecord::Type::Integer.new
  attribute :chupou_dedo, ActiveRecord::Type::Integer.new
  attribute :roe_unhas, ActiveRecord::Type::Integer.new
  attribute :arranca_cabelos, ActiveRecord::Type::Integer.new
end
