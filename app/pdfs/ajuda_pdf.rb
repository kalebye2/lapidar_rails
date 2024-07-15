class AjudaPdf < BasePdf
  def initialize()
    super()
    @texto = File.read "#{Rails.root}/public/ajuda.md"
    @main_color = "dd0000"

    @markup_options = {
      text: {
        align: :justify,
        indent_paragraphs: 24,
        leading: 5,
        character_spacing: 0,
      },
      heading1: {
        align: :left,
        style: :bold,
        indent_paragraphs: 0,
        leading: 15,
        color: @main_color,
      },
      heading2: {
        align: :left,
        leading: 3,
        size: 16,
        style: :italic,
        indent_paragraphs: 0,
      },
      heading3: {
        align: :left,
        leading: 2,
        font_size: 8,
        style: :italic,
        indent_paragraphs: 0,
      },
    }

    header
    title
    body
    footer

    number_pages "<page> / <total>", at: [bounds.left, -10], align: :center
  end

  def header
    gerar_cabecalho "Ajuda - Lapidar"
  end

  def title
    font @heading_font, style: :bold
    text "Como usar a aplicação".upcase, align: :center, size: 36
    move_down 14
    font @body_font
  end

  def body
    markup markdown_to_html(@texto), @markup_options
  end

  def footer
  end
end
