class RecebimentoReciboPdf < BasePdf
  def initialize(recebimento)
    super()
    @recebimento = recebimento
    @titulo = "Recibo de honorários profissionais"
    title
    body
    footer
  end

  def title
    move_down 7
    font @heading_font, style: :bold
    text @titulo, align: :center, size: 24
    move_down 100
    font @body_font
  end

  def body
    text "Recebi de <b>#{@recebimento.pagante.nome_completo}</b>" \
      ", CPF #{@recebimento.pagante.render_cpf}" \
      ", a quantia de <b>#{render_dinheiro_centavos @recebimento.valor}</b>" \
      " referente ao serviço de #{@recebimento.acompanhamento.tipo.upcase}" \
      "#{@recebimento.pagante != @recebimento.pessoa ? " para <b>#{@recebimento.pessoa.nome_completo}</b>" : ""}.", align: :justify, inline_format: true

    move_down 50

    text "#{@recebimento.profissional.cidade}, #{render_data_extenso @recebimento.data}", align: :center

    local_assinatura "#{@recebimento.profissional.nome_completo}\n#{@recebimento.profissional.render_cpf}\n#{@recebimento.profissional.documento}"
  end

  def footer
    move_down 60
    stroke_horizontal_rule

    move_down 10
    text "<b>Anotações #{@recebimento.profissional.funcao}</b>", inline_format: true

    move_down 10
    text "Data: #{render_data_brasil @recebimento.data}"
    move_down 10
    text "Pcte: #{@recebimento.pessoa.nome_completo}"

    if @recebimento.pagante != @recebimento.pessoa
      text "Pagante: #{@recebimento.pagante.nome_completo}"
    end

    move_down 10
    text "CPF Pagante: #{@recebimento.pagante.render_cpf}"

    move_down 10
    text "Valor: #{render_dinheiro_centavos @recebimento.valor}"

    move_down 10
    text "Referente: Serviço de #{@recebimento.profissional.servico}"

    move_down 10
    draw_text "Documento gerado em #{Time.now}", size: 6, at: [bounds.left, -10]
  end
end
