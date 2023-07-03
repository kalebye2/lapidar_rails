class AtendimentoTipo < ApplicationRecord
  has_many :atendimentos, inverse_of: :atendimento_tipo
end
