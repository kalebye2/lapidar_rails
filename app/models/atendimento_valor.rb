class AtendimentoValor < ApplicationRecord
  self.primary_key = :atendimento_id

  belongs_to :atendimento, foreign_key: :atendimento_id, primary_key: :id

  has_one :acompanhamento, through: :atendimento

  def data
    atendimento.data
  end

  def horario
    atendimento.horario
  end

  def pessoa
    atendimento.acompanhamento.pessoa
  end

end
