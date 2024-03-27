class PessoaProntuarioPdf < BasePdf
  def initialize(pessoa=Pessoa.new)
    super()
    @pessoa = pessoa
    header
    title
    move_down 7
    body
    footer
  end

  def header
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
    markup "<h1>Dados cadastrais</h1>"

    move_down 7

    # fazer alterações necessárias
    dados = @pessoa.dados_cadastrais
    dados[:fone] = "<a href='tel:#{@pessoa.render_fone_link}'>#{@pessoa.render_fone}</a>" \
      "#{if @pessoa.usa_whatsapp? then " | <a href='#{@pessoa.render_whatsapp_link}'>Whatsapp</a>" end}" \
      "#{if @pessoa.usa_telegram? then " | <a href='#{@pessoa.render_telegram_link}'>Telegram</a>" end}" \
        ""
    dados[:email] = "<a href='mailto:#{@pessoa.email.downcase}'>#{@pessoa.email}</a>"
    dados[:toma_medicação] = dados[:toma_medicação] || "Sem informações de medicação"

    markup dados.map { |k,v| "<b>#{k&.to_s&.humanize}</b>: #{v&.upcase}" }.join("\n<br>\n")
  end

  def atendimentos
    @pessoa.atendimentos.em_ordem.each_with_index do |atendimento, index|
      start_new_page
      markup "<h1>Atendimento nº #{index + 1}</h1>"
      move_down 1.cm
      markup atendimento.dados_do_atendimento(true).compact.map { |k,v| "<b>#{k.to_s.humanize}</b>: #{v}" }.join("\n<br>\n")
      move_down 7
    end
  end

  def local_assinatura texto=""
  end

  def footer
  end
end
