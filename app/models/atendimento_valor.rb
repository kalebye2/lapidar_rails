class AtendimentoValor < ApplicationRecord
  self.primary_key = :atendimento_id

  belongs_to :atendimento, foreign_key: :atendimento_id, primary_key: :id

  def data
    atendimento.data
  end

  def horario
    atendimento.horario
  end

  def usuario
    atendimento.acompanhamento.usuario
  end

end
