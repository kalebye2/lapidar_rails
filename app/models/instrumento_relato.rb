class InstrumentoRelato < ApplicationRecord
  belongs_to :atendimento
  belongs_to :instrumento
  has_one :acompanhamento, through: :atendimento
  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento

  def paciente
    pessoa
  end

  def self.decrescente
    joins(:atendimento).order("atendimentos.data" => :desc, "atendimentos.horario" => :desc)
  end
end
