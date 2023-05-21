class Especializacao < ApplicationRecord
  has_and_belongs_to_many :profissional, through: :profissional_especializacao_juncoes
end
