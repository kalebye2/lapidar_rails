class Atendimento < ApplicationRecord
  belongs_to :acompanhamento
  belongs_to :atendimento_local
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id
  belongs_to :atendimento_valor, foreign_key: :id, primary_key: :atendimento_id

end
