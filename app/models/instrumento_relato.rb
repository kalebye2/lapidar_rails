class InstrumentoRelato < ApplicationRecord
  belongs_to :atendimento
  belongs_to :instrumento


  def self.decrescente
    joins(:atendimento).order("atendimentos.data" => :desc, "atendimentos.horario" => :desc)
  end
end
