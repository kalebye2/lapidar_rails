class PessoaPdf < BasePdf
  def initialize(pessoa = Pessoa.new)
    super()
    @pessoa = pessoa
    header
    move_down 7
    stroke_horizontal_rule
    body
  end

  def header
    font @heading_font, style: :bold
    text "Ficha de cadastro", size: 9, align: :right
    move_down 7
    text "#{@pessoa.nome_completo} #{@pessoa.render_sexo_sigla}", size: 30, align: :center
  end

  def body
    font @body_font, size: 20
    text "a", size: 0
    text "CPF #{@pessoa.render_cpf}", align: :center
    text "#{@pessoa.data_nascimento ? @pessoa.data_nascimento.strftime("%d/%m/%Y") : 'Data de nascimento não informada'}", align: :center
    text "<a href='mailto:#{@pessoa.email}'><color rgb='0000FF'>#{@pessoa.email}</color></a>", inline_format: true
    text "<a href='tel:#{@pessoa.render_fone_link}'><color rgb='0000FF'>#{@pessoa.render_fone}</a> | <a href='https://wa.me/#{@pessoa.render_fone_link}'>Whatsapp</color></a>", inline_format: true

    text @pessoa.estado_civil.capitalize
    text @pessoa.instrucao_grau.grau

    text "#{@pessoa.render_endereco} #{@pessoa.endereco_cep ? ' - CEP ' + @pessoa.render_cep : nil}"
    text "#{@pessoa.render_cidade_estado}"
    text "#{@pessoa.pais.nome} (#{@pessoa.pais.continente.nome})"
  end
end
