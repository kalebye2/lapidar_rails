class RelatoPdf < BasePdf
  def initialize(relato = Relato.new)
    super()
    @relato = relato
    heading
    move_down 10
    stroke_horizontal_rule
    move_down 20
    body
    number_pages '<page>', @page_num_options
  end

  def heading
    font @heading_font
    text "Relato", size: 24, style: :normal
    text "#{@relato.atendimento.pessoa.nome_completo}", size: 30, style: :bold
    move_down 7
    text "#{@relato.atendimento.tipo} - #{@relato.atendimento.data.strftime("%d/%m/%Y")} às #{@relato.atendimento.horario.strftime("%Hh%M")}", style: :bold
    move_down 5
    text "Documento gerado em " + (Date.today.strftime("%d/%m/%Y")) + " às " + (Time.now.strftime("%Hh%M")), size: 9
  end

  def body
    font @body_font
    #text Kramdown::Document.new(relato.relato).to_html
    #text Kramdown::Document.new(@relato.relato).to_html, inline_format: true
    text @relato.relato
  end
end
