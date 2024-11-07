class InstrumentoRelatoPdf < BasePdf
  def initialize(instrumento_relato = InstrumentoRelato.new)
    super()
    @instrumento_relato = instrumento_relato
    @markup_options = {
      text: {
        align: :justify,
        # indent_paragraphs: 24,
        leading: 5,
      },
      heading1: {
        align: :left,
        style: :bold,
        indent_paragraphs: 0,
      },
      heading2: {
        style: :bold,
        size: 16,
      },
      heading3: {
        style: :italic,
        size: 12,
      },
      table: {
        header: {
          style: :bold,
        }
      }
    }

    heading
    default_leading 10
    move_down 7
    move_down 10
    body

    number_pages "<page>", at: [bounds.left, 0], align: :center
  end

  def heading
    font @heading_font
    gerar_cabecalho "Detalhes de aplicação: #{@instrumento_relato.instrumento.sigla || @instrumento_relato.instrumento.nome} #{@instrumento_relato.atendimento.data_inicio_verdadeira.strftime("%Y%m%d")}#{@instrumento_relato.id.hash}", style: :bold, align: :right
    # text "Detalhes de aplicação", style: :bold, align: :right
    # move_down 7
    text @instrumento_relato.instrumento.nome_e_sigla, style: :bold, size: 24
  end

  def body
    font @body_font
    dados = @instrumento_relato.dados(formato_data: "%d/%m/%Y").compact.except(:nome_instrumento, :sigla_instrumento)
    markup dados.map { |k,v| "<h2>#{k.to_s&.humanize&.upcase}</h2>#{v.instance_of?(Hash) ? v.compact.map { |k,v| "<p><b>#{k.to_s.humanize}</b>: #{v&.to_s&.upcase}</p>"}.join("\n") : v&.to_s}" }.join("\n")
  end
end
