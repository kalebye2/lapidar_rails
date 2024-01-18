class BasePdf < Prawn::Document
  include ApplicationHelper
  include ActionView::Helpers::TranslationHelper
  def initialize(model = nil, page_size: 'A4', margin: [50, 100, 140, 200])
    super(page_size: page_size)
    font_families.update(
    "Liberation Sans" => {
      normal: Rails.root.join("public/assets/fonts/liberation/LiberationSans-Regular.ttf"),
      bold: Rails.root.join("public/assets/fonts/liberation/LiberationSans-Bold.ttf"),
      italic: Rails.root.join("public/assets/fonts/liberation/LiberationSans-Italic.ttf"),
      bolditalic: Rails.root.join("public/assets/fonts/liberation/LiberationSans-BoldItalic.ttf"),
    },
  )

    # @heading_font = "Helvetica"
    # @body_font = "Helvetica"
    @heading_font = "Liberation Sans"
    @body_font = "Liberation Sans"

    @page_num_options = {
      align: :center,
      at: [0,0]
    }
  end

  def local_assinatura quem_assina = ''
    # text "#{@laudo.profissional.cidade}, #{@laudo.data_avaliacao.day} de #{} de #{@laudo.data_avaliacao.year}", align: :center
    last_cursor = cursor
    if last_cursor < 200
    start_new_page
    move_down bounds.height / 2
    else
      move_down 72 * 2
    end
    rule_size = 130
    stroke_horizontal_line bounds.width / 2 - rule_size, bounds.width / 2 + rule_size
    move_down 7
    text "#{quem_assina}", align: :center
  end
end
