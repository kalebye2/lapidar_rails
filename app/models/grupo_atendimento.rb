class GrupoAtendimento < ApplicationRecord
  belongs_to :grupo
  belongs_to :modalidade
  belongs_to :atendimento_local
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id, inverse_of: :atendimentos
end
