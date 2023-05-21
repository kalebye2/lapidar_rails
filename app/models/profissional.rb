class Profissional < ApplicationRecord
  belongs_to :pessoa
  has_and_belongs_to_many :especializacao, through: :profissional_especializacao_juncoes
end
