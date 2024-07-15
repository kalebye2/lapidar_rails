class PessoaPdf < BasePdf
  def initialize(pessoa = Pessoa.new)
    super()
    @pessoa = pessoa
    default_leading 10
    header
    move_down 7
    stroke_horizontal_rule
    move_down 7
    body
  end

  def header
    font @heading_font, style: :bold
    text "Ficha de cadastro", size: 9, align: :right
    move_down 7
    text "#{@pessoa.nome_completo}", size: 30, align: :center
  end

  def body
    font @body_font, size: 20
    text "a", size: 0
    text "CPF #{@pessoa.render_cpf}", align: :center
    text "RG #{@pessoa.render_rg}", align: :center
    text "#{@pessoa.data_nascimento ? @pessoa.data_nascimento.strftime("%d/%m/%Y") : 'Data de nascimento não informada'}", align: :center
    text "<a href='mailto:#{@pessoa.email}'><color rgb='0000FF'>#{@pessoa.email}</color></a>", inline_format: true, align: :center
    # text "<a href='tel:#{@pessoa.render_fone_link}'><color rgb='0000FF'>#{@pessoa.render_fone}</a> | <a href='https://wa.me/#{@pessoa.render_fone_link}'>Whatsapp</color></a>", inline_format: true
    text "<a href='tel:#{@pessoa.render_fone_link}'><color rgb='0000FF'>#{@pessoa.render_fone}</color></a>" \
      "#{if @pessoa.usa_whatsapp then " | <a href='#{@pessoa.render_whatsapp_link}'><color rgb='0000FF'>Whatsapp</color></a>" end}" \
      "#{if @pessoa.usa_telegram then " | <a href='#{@pessoa.render_telegram_link}'><color rgb='0000FF'>Telegram</color></a>" end}" \
        "", align: :center, inline_format: true

    move_down 24

    text @pessoa.render_sexo
    text @pessoa.estado_civil&.capitalize
    text @pessoa.instrucao_grau&.grau

    text "#{@pessoa.endereco_completo_com_cep}"

    if @pessoa.bio
      move_down 24
      stroke_horizontal_rule
      font @body_font, size: 11
      move_down 24
      text "Breve biografia", size: 24, style: :bold
      markup(markdown_to_html(@pessoa.bio))
    end
  end
end
