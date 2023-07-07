class ProfissionalEspecializacao < ApplicationRecord
  has_many :profissional_especializacao_juncoes
  has_many :profissionais, through: :profissional_especializacao_juncoes

end
