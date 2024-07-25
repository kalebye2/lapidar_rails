class AdultoAnamnesePdf < BasePdf
  def initialize(anamnese=Anamnese.new)
    super
    @anamnese = anamnese
    @markup_options = {
      text: {
        align: :justify,
        indent_paragraphs: 24,
        leading: 5,
      },
      heading1: {
        align: :right,
        size: 24,
        style: :bold,
        indent_paragraphs: 0,
        leading: 10,
      },
      heading2: {
        style: :bold,
        size: 12,
        indent_paragraphs: 0,
      },
      heading3: {
        style: :italic,
        size: 12,
        indent_paragraphs: 0,
      },
      table: {
        header: {
          style: :bold,
        }
      }
    }

    header
    move_down 24
    title
    body
    footer
    number_pages "Página <page>", at: [bounds.left, -10], align: :center
  end

  def header
    gerar_cabecalho "Anamnese - #{@anamnese.pessoa.nome_completo}".upcase
  end

  def title
    font @heading_font, style: :bold
    text "Anamnese ", size: 28, align: :center
    font @body_font
    move_down 24
  end

  def body
    dados_texto
    # dados_tabela
  end

  def dados_texto
    os_dados = @anamnese.dados.map do |k,v|
      "<h1>#{k.to_s.humanize}</h1>\n" \
        "" \
        "#{v&.map { |k,v| "<h2>#{k.to_s.humanize}</h2> #{markdown_to_html v || "\n<br>\n"}" }&.join("\n")}" \
        ""
    end

    markup os_dados.join("\n<br>\n"), @markup_options
  end

  def dados_tabela
    os_dados = @anamnese.dados.map do |k,v|
      "## #{k.to_s.humanize}\n" \
        "" \
        "|#{v&.map { |k,v| "|#{k.to_s.humanize}|#{markdown_to_html v}|" }&.join("\n")}" \
        ""
    end

    markup markdown_to_html("#{os_dados}")
  end

  def footer
  end
end
