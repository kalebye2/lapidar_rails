class InstrumentoRelato < ApplicationRecord
  belongs_to :atendimento
  belongs_to :instrumento
  has_one :acompanhamento, through: :atendimento
  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento

  scope :em_ordem, -> (ordem = :asc) { includes(:atendimento).sort_by { |relato| "#{relato.atendimento.data_inicio_verdadeira.strftime("%Y%m%d")}#{relato.atendimento.horario_inicio_verdadeiro.strftime("%H:%M:%S")}" } }
  # scope :em_ordem, -> (ordem = :asc) { InstrumentoRelato.connection.execute("SELECT #{InstrumentoRelato.attribute_names.map { |attr| "instrumento_relatos.#{attr}" }.to_sentence(last_word_connector: ", ")} FROM instrumento_relatos JOIN atendimentos ON instrumento_relatos.atendimento_id = atendimentos.id ORDER BY COALESCE(atendimentos.data_reagendamento, atendimentos.data) #{ordem}, COALESCE(atendimentos.horario_reagendamento, atendimentos.horario) #{ordem}") }

  def paciente
    pessoa
  end

  def self.decrescente
    joins(:atendimento).order("atendimentos.data" => :desc, "atendimentos.horario" => :desc)
  end

  def dados nome_instrumento: true, sigla_instrumento: true, formato_data: "%Y-%m-%d", formato_hora: "%H:%M"
    {
      nome_instrumento: nome_instrumento ? instrumento.nome : nil,
      sigla_instrumento: sigla_instrumento ? instrumento.sigla : nil,
      identificação: {
        aplicador: profissional.descricao_completa,
        paciente: pessoa.nome_completo,
        responsável: atendimento.responsavel&.nome_completo,
        data: atendimento.data_inicio_verdadeira.strftime(formato_data),
        horário: atendimento.horario_inicio_verdadeiro.strftime(formato_hora),
        tipo: atendimento.tipo.upcase,
        contexto: acompanhamento.tipo.upcase,
        queixa_principal: acompanhamento.motivo.upcase,
      },
      relato: Kramdown::Document.new(relato.to_s).to_html.presence,
      resultados: Kramdown::Document.new(resultados.to_s).to_html.presence,
      observações: Kramdown::Document.new(observacoes.to_s).to_html.presence,
    }
  end

  def para_csv formato_data: "%Y-%m-%d", formato_hora: "%H:%M"
    CSV.generate do |csv|
      csv << [
        instrumento.nome,
        instrumento.sigla,
        instrumento.tipo&.upcase,
        profissional.descricao_completa,
        pessoa.nome_completo,
        pessoa.idade_anos,
        atendimento.responsavel&.nome_completo,
        atendimento.data_inicio_verdadeira.strftime(formato_data),
        atendimento.horario_inicio_verdadeiro.strftime(formato_hora),
        atendimento.tipo.upcase,
        acompanhamento.tipo.upcase,
        acompanhamento.motivo.upcase,
      ]
    end
  end

  def self.para_csv collection=all, formato_data: "%Y-%m-%d", formato_hora: "%H:%M", col_sep: ","
    CSV.generate(col_sep: col_sep) do |csv|
      csv << [
        "nome_instrumento",
        "sigla_instrumento",
        "tipo_instrumento",
        "aplicador",
        "paciente",
        "idade_paciente",
        "responsavel",
        "data_aplicacao",
        "horario_aplicacao",
        "tipo_atendimento",
        "contexto",
        "motivo_acompanhamento",
      ]

      collection.each do |relato|
        csv << [
          relato.instrumento.nome,
          relato.instrumento.sigla,
          relato.instrumento.tipo&.upcase,
          relato.profissional.descricao_completa,
          relato.pessoa.nome_completo,
          relato.pessoa.idade_anos,
          relato.atendimento.responsavel&.nome_completo,
          relato.atendimento.data_inicio_verdadeira.strftime(formato_data),
          relato.atendimento.horario_inicio_verdadeiro.strftime(formato_hora),
          relato.atendimento.tipo.upcase,
          relato.acompanhamento.tipo.upcase,
          relato.acompanhamento.motivo.upcase,
        ]
      end
    end
  end
end
