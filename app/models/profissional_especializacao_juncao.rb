class ProfissionalEspecializacaoJuncao < ApplicationRecord
  has_many :profissionais
  has_many :profissional_especializacoes
end
