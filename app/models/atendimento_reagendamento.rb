class AtendimentoReagendamento < ApplicationRecord
  belongs_to :atendimento
  has_one :acompanhamento, through: :atendimento
  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  scope :de_hoje, -> { where(data: Date.today) }

end
