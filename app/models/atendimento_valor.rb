class AtendimentoValor < ApplicationRecord
  self.primary_key = :atendimento_id

  belongs_to :atendimento, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento_valor

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

  def taxa_valor
    valor * taxa_porcentagem / 10000
  end
end
