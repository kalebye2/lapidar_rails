class LaudoPdf < BasePdf
  def initialize(laudo = Laudo.new)
    super()
    @laudo = laudo
    header
    title
    move_down 7
    body
    local_assinatura @laudo.profissional.descricao_completa.gsub(" - ", "\n")
    footer
    number_pages "Página <page> / <total>", at: [bounds.left, -10], align: :center
  end

  def header
    gerar_cabecalho "Laudo #{@laudo.profissional.profissional_funcao.adjetivo_masc}".upcase
  end

  def title
    font @heading_font, style: :bold
    text "Laudo #{@laudo.profissional.profissional_funcao.adjetivo_masc}", size: 24, align: :center
    move_down 20

    markup "<b>Profissional</b>: #{@laudo.profissional.descricao_completa}"
    markup "<b>E-mail</b>: <a href=\"mailto:#{@laudo.profissional.email}\">#{@laudo.profissional.email}</a>"
    markup "<b>Telefone para contato</b>: <a href=\"tel:#{@laudo.profissional.render_fone_link}\">#{@laudo.profissional.render_fone}</a>" \
      "#{" | <a href=\"https://wa.me/#{@laudo.profissional.render_fone_link.gsub("+", "")}\">Whatsapp</a>" unless !@laudo.profissional.usa_whatsapp?}" \
      "#{" | <a href=\"https://t.me/#{@laudo.profissional.render_fone_link}\">Telegram</a>" unless !@laudo.profissional.usa_telegram?}"

    move_down 14

    font @body_font
    
    # Tabela
    dados = [
      ["Avaliad#{@laudo.pessoa.no_feminino? ? "a" : "o"}", "#{@laudo.pessoa.nome_completo} #{@laudo.pessoa.render_sexo_sigla}"],
      ["Data da avaliação", @laudo.data_avaliacao.strftime("%d/%m/%Y")],
      ["Idade na avaliação", @laudo.pessoa.render_idade(@laudo.data_avaliacao)],
      ["Interessado", @laudo.interessado || @laudo.pessoa.nome_completo],
      ["Tempo de avaliação", "#{@laudo.dias_de_avaliacao} dias"],
      ["Nº de sessões", @laudo.numero_de_sessoes],
    ]
    markup_tabela_lado_a_lado dados
    # text @laudo.instrumentos_aplicados.to_a.to_s
  end

  def body
    # markup_atributo_textual "Técnicas utilizadas", :tecnicas
    #
    # COLOQUE AS INFORMAÇÕES BÁSICAS AQUI

    # markup_atributo_textual "Demanda", :demanda
    # markup_atributo_textual "Análise", :analise
    # markup_atributo_textual "Conclusão", :conclusao

    markup(markdown_to_html(@laudo.texto_completo), text: {align: :justify, leading: 5, indent_paragraphs: 24}, heading1: {align: :left, indent_paragraphs: 0, style: :bold, size: 24})
  end

  def signature
    # text "#{@laudo.profissional.cidade}, #{@laudo.data_avaliacao.day} de #{} de #{@laudo.data_avaliacao.year}", align: :center
    last_cursor = cursor
    if last_cursor < 0
    start_new_page
    move_down bounds.height / 2
    end
    rule_size = 130
    stroke_horizontal_line bounds.width / 2 - rule_size, bounds.width / 2 + rule_size
    move_down 7
    text @laudo.profissional.descricao_completa, align: :center
  end

  def footer
  end

  private
  def markup_atributo_textual titulo="", atributo=""
    font @heading_font, style: :bold
    text titulo, size: 14
    move_down 14
    font @body_font
    markup(markdown_to_html(@laudo.substituir_template_por_dados(atributo)), text: { align: :justify, leading: 5 })
  end
end
