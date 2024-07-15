class BasePdf < Prawn::Document
  include ApplicationHelper
  include MarkdownHelper
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::NumberHelper

  # margins are margin[top, right, bottom, left]
  def initialize(model = nil, page_size: 'A4', margin: [70, 70, 70, 70], options: {}, info: {}, **kwargs)
    super(page_size: page_size, margin: margin, **kwargs)
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
    @margin = margin

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

  def gerar_cabecalho texto1, texto2="", align: :right, size: 10, style: :bold, displace: @margin[0] / 2
      repeat :all do
        bounding_box [bounds.left, bounds.top + displace + size],
          width: bounds.width do
            text "#{texto1}",
              size: size, align: align, style: style
          end
        stroke_horizontal_rule
        move_down size
      end
  end

  def gerar_rodape_nome_clinica align: :center, size: 10, style: :normal, displace: @margin[0] / 2
    repeat :all do
      # text_box "#{titulo_da_aplicacao}", size: size, align: align, style: style, at: [bounds.left, 0]
      # bounding_box [bounds.left, bounds.bottom + size],
      #   width: bounds.width do
      #     text "#{titulo_da_aplicacao}", size: size, align: align, style: style
      #   end
    end
  end

  def numerar_paginas_simples
  end

  def markup_tabela_lado_a_lado dados = []
    dados_tabela = ""
    dados.each do |dado|
      dados_tabela += "<tr><th><b>#{dado[0]}</b></th><td>#{dado[1]}</td>"
    end
    markup "<table>#{dados_tabela}</table>"
  end
end
