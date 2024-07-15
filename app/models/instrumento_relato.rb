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

  def dados nome_instrumento: true
    {
      nome_instrumento: nome_instrumento ? instrumento.nome : nil,
      relato: Kramdown::Document.new(relato.to_s).to_html.presence,
      resultados: Kramdown::Document.new(resultados.to_s).to_html.presence,
      observações: Kramdown::Document.new(observacoes.to_s).to_html.presence,
    }
  end
end
