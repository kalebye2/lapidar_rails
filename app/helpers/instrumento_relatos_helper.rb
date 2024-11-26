module InstrumentoRelatosHelper
  def titulo_simples instrumento_relato
    "#{render_data_brasil instrumento_relato.atendimento.data}: #{instrumento_relato.dados.slice(:nome_instrumento, :sigla_instrumento).values.compact.join " - "}"
  end
end
