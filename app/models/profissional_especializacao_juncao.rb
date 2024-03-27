class ProfissionalEspecializacaoJuncao < ApplicationRecord
  belongs_to :profissional
  belongs_to :profissional_especializacao
end
