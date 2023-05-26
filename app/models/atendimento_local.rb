class AtendimentoLocal < ApplicationRecord
  belongs_to :atendimento_local_tipo
  has_many :atendimento

end
