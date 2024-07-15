class PessoaDevolutivaPdf < BasePdf
  def initialize(pessoa_devolutiva)
    super()
    @pessoa_devolutiva = pessoa_devolutiva
    @titulo = "Devolutiva #{@pessoa_devolutiva.profissional.profissional_funcao.adjetivo_fem}"
    @markup_options = {
      text: {
        align: :justify,
        indent_paragraphs: 24,
        leading: 5,
      },
      heading1: {
        align: :left,
        style: :bold,
        indent_paragraphs: 0,
      }
    }

    gerar_cabecalho @titulo.upcase
    title
    body
    footer
    number_pages "<page>/<total>", at: [bounds.left, -10], align: :center
  end

  def title
    font @heading_font, style: :bold
    text @titulo, align: :center, size: 36
    move_down 20
    font @body_font
  end

  def body
    markup_tabela_lado_a_lado @pessoa_devolutiva.dados_principais.compact.map { |k,v| [k&.to_s&.humanize, v] }
    move_down 10

    markup "<h1>Feedback</h1>", @markup_options
    markup markdown_to_html(@pessoa_devolutiva.substituir_template_por_dados :feedback_responsavel), @markup_options
    move_down 7

    markup "<h1>Orientações do profissional</h1>", @markup_options
    markup markdown_to_html(@pessoa_devolutiva.substituir_template_por_dados :orientacoes_profissional), @markup_options
  end

  def footer
  end
end
