class AcompanhamentoDeclaracaoIrPdf < BasePdf
  def initialize(acompanhamento, ano: (Date.current - 1.year).year)
    super()
    @acompanhamento = acompanhamento
    @titulo = "Recibo de quitação anual"
    @ano = ano
    @periodo = Date.new(ano, 1, 1).all_year
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
    pagante = @acompanhamento.pessoa_responsavel || @acompanhamento.pessoa
    text "Recebi de <b>#{pagante.nome_completo}</b>" \
      ", CPF #{pagante.render_cpf}" \
      ", a quantia de <b>#{render_dinheiro_centavos @acompanhamento.valor_recebido_no_periodo @periodo}</b>" \
      " referente ao serviço de <b>#{@acompanhamento.tipo.upcase}</b>" \
      "#{@acompanhamento.pessoa_responsavel ? " para <b>#{@acompanhamento.pessoa.nome_completo}</b>" : ""}" \
      " para o ano de #{@ano}.", align: :justify, inline_format: true

    move_down 100

    text "#{@acompanhamento.cidade}, #{render_data_extenso Date.current}", align: :center

    local_assinatura "#{@acompanhamento.profissional.nome_completo}\n#{@acompanhamento.profissional.render_cpf}\n#{@acompanhamento.profissional.documento}"
  end

  def footer
    move_cursor_to 8
    text "Documento gerado em #{render_data_extenso Date.current} às #{Time.now.strftime "%H:%M:%S"}", align: :center, size: 8
  end
end
