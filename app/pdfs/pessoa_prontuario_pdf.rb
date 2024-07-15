class PessoaProntuarioPdf < BasePdf
  def initialize(pessoa=Pessoa.new, instrumentos: true)
    super()
    @pessoa = pessoa
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

    @instrumentos = instrumentos
    header
    title
    move_down 7
    body
    footer
    number_pages "<page>", at: [bounds.left, -10], align: :right
  end

  def header
    gerar_cabecalho "Prontuário multiprofissional - #{@pessoa.nome_completo}".upcase
  end

  def title
    font @heading_font, style: :bold
    text "Prontuário multiprofissional", size: 36, align: :center
    move_down 20
    font @body_font
  end

  def body
    # dados cadastrais
    dados_cadastrais
    move_down 14
    atendimentos
  end
  
  def dados_cadastrais
    markup "<h1>Dados cadastrais</h1>", @markup_options

    move_down 7

    # fazer alterações necessárias
    dados = @pessoa.dados_cadastrais
    dados[:fone] = "<a href='tel:#{@pessoa.render_fone_link}'>#{@pessoa.render_fone}</a>" \
      "#{if @pessoa.usa_whatsapp? then " | <a href='#{@pessoa.render_whatsapp_link}'>Whatsapp</a>" end}" \
      "#{if @pessoa.usa_telegram? then " | <a href='#{@pessoa.render_telegram_link}'>Telegram</a>" end}" \
        ""
    dados[:email] = "<a href='mailto:#{@pessoa.email.downcase}'>#{@pessoa.email}</a>"
    dados[:medicação] = dados[:medicação]

    markup dados.map { |k,v| "<b>#{k&.to_s&.humanize}</b>: #{v&.upcase}" }.join("\n<br>\n")
  end

  def atendimentos instrumentos: @instrumentos
    @pessoa.atendimentos.em_ordem.each_with_index do |atendimento, index|
      start_new_page
      markup "<h1>Atendimento nº #{index + 1}</h1>", @markup_options
      move_down 1.cm
      markup atendimento.dados_do_atendimento(true).compact.map { |k,v| "<b>#{k.to_s.humanize}</b>: #{v}" }.join("\n<br>\n"), @markup_options

      if instrumentos && atendimento.instrumento_relatos.presence
        markup "<h2>Relatos de instrumentos aplicados</h2>", {heading2: {style: :bold, size: 16}}
        atendimento.instrumento_relatos.map do |instrumento_relato|
          markup "<h3>#{instrumento_relato.instrumento.nome}</h3>", {heading3: {style: :italic, size: 14}}
          markup instrumento_relato.dados(nome_instrumento: false).compact.map { |k,v| "<b>#{k.to_s.humanize}</b>: #{v}" }.join("\n<br>\n")
        end
      end
      move_down 7
    end
  end

  def local_assinatura texto=""
  end

  def footer
    number_pages "#{titulo_da_aplicacao}", at: [bounds.left, -10], align: :center
  end
end
