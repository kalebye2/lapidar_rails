class AcompanhamentoProntuarioPdf < BasePdf
  def initialize(acompanhamento = Acompanhamento.new, instrumentos: true, options: {})
    super
    @acompanhamento = acompanhamento
    @options = options
    @titulo = "Prontuário #{@acompanhamento.profissional.profissional_funcao.adjetivo_masc}"
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

    @instrumento_relatos = instrumentos
    
    header
    title
    move_down 7
    body
    # local_assinatura @acompanhamento.profissional.descricao_completa.gsub(' - ', "\n")
    footer
    number_pages "<page>", at: [bounds.left, 0], align: :center
  end

  def header
    gerar_cabecalho "#{@titulo} - #{@acompanhamento.pessoa.nome_completo}".upcase
  end

  def title
    move_down 36
    font @heading_font, style: :bold
    text @titulo, size: 36, align: :center
    move_down 36
  end

  def body
    font @body_font
    dados_cadastrais
    font @heading_font, style: :bold
    font @body_font
    @acompanhamento.atendimentos.each_with_index do |atendimento, index|
      start_new_page
      font @heading_font, style: :bold
      markup "<h2><b>Atendimento nº #{index + 1}</b></h2>", @markup_options
      font @body_font
      dados_atendimento atendimento
    end
  end

  def footer
  end

  private

  def dados_cadastrais_alt
    dado_cadastral "Nome do paciente", @acompanhamento.paciente.nome_completo
    if @acompanhamento.paciente.nome_preferido then dado_cadastral "Nome preferido", @acompanhamento.paciente.nome_preferido end
    dado_cadastral "Data de nascimento", render_data_brasil(@acompanhamento.paciente.data_nascimento)
    dado_cadastral "Idade", @acompanhamento.paciente.render_idade
    dado_cadastral "Sexo", @acompanhamento.paciente.render_sexo
    if @options[:trans]
      dado_cadastral "Identificação sexual", @acompanhamento.paciente.inverter_pronome_tratamento ? 'transexual' : 'cisgênero'
    end
    if @options[:orientacao_sexual] then dado_cadastral "Orientação sexual", @acompanhamento.paciente.orientacao_sexual end
    dado_cadastral "Estado civil", @acompanhamento.paciente.estado_civil
    dado_cadastral "Grau de instrucao", @acompanhamento.paciente.grau_de_instrucao
    dado_cadastral "Profissão", @acompanhamento.paciente.profissao || "Não informada"

    dado_cadastral "Fone", "<a href=tel:#{@acompanhamento.paciente.render_fone_link}>#{@acompanhamento.paciente.render_fone}</a>" \
      "#{@acompanhamento.paciente.usa_whatsapp? ? " | <a href='#{@acompanhamento.paciente.render_whatsapp_link}'>Whatsapp</a>" : ""}"
      "#{@acompanhamento.paciente.usa_telegram? ? " | <a href='#{@acompanhamento.paciente.render_telegram_link}'>Telegram</a>" : ""}"

    dado_cadastral "E-mail", "<a href='mailto:#{@acompanhamento.paciente.email}'>#{@acompanhamento.paciente.email}</a>"
    # dado_cadastral "Contato para emergência", @acompanhamento.pessoa_responsavel.presence ? "#{@acompanhamento.pessoa_responsavel.nome_completo} - <a href='tel:#{@acompanhamento.pessoa_responsavel.render_fone_link}'>#{(@acompanhamento.pessoa_responsavel.render_fone)}</a>" : "inserir contato para emergência"
    dado_cadastral "Contato para emergência", @acompanhamento.pessoa.parentescos_registrados.parentes.map { |parente| "#{parente.parente.nome_completo.upcase}: <a href='tel:#{parente.parente.render_fone_link}'>#{parente.parente.render_fone}</a>" unless parente.parente.render_fone.empty? }.join(' | ')
    # TODO RG
    dado_cadastral "CPF", @acompanhamento.paciente.render_cpf
    dado_cadastral "Endereço", "#{@acompanhamento.paciente.endereco_completo_com_cep}"
    # TODO toma medicação
    dado_cadastral "Motivo da consulta", @acompanhamento.motivo
    dado_cadastral "Toma medicação", @acompanhamento.pessoa.pessoa_medicacoes.map(&:medicacao).to_sentence(last_word_connector: ' e ')
    # TODO hipótese diagnóstica
    # TODO objetivo do acompanhamento
    dado_cadastral "Início do acompanhamento", render_data_brasil(@acompanhamento.primeiro_atendimento.data)
    # dado_cadastral "Status", @acompanhamento.status
    move_down 12
    horizontal_rule
    move_down 12
    dado_cadastral "#{@acompanhamento.profissional.funcao}", @acompanhamento.profissional.descricao_completa
    move_down 12
  end

  def dados_cadastrais
    dados = @acompanhamento.paciente.dados_cadastrais
    dados[:fone] = "<a href='tel:#{@acompanhamento.paciente.render_fone_link}'>#{@acompanhamento.paciente.render_fone}</a>" \
      "#{if @acompanhamento.paciente.usa_whatsapp? then " | <a href='#{@acompanhamento.paciente.render_whatsapp_link}'>Whatsapp</a>" end}" \
      "#{if @acompanhamento.paciente.usa_telegram? then " | <a href='#{@acompanhamento.paciente.render_telegram_link}'>Telegram</a>" end}" \
        ""
    dados[:email] = "<a href='mailto:#{@acompanhamento.paciente.email.downcase}'>#{@acompanhamento.paciente.email}</a>"

    markup dados.map { |k,v| "<b>#{k&.to_s&.humanize}</b>: #{v&.upcase}" }.join("\n<br>\n")
    move_down 12
    horizontal_rule
    move_down 12
    dado_cadastral "#{@acompanhamento.profissional.funcao}", @acompanhamento.profissional.descricao_completa
    move_down 12
  end

  def dado_cadastral titulo="", texto=""
    markup "<b>#{titulo}</b>: #{texto&.to_s&.upcase}"
  end

  def dados_atendimento atendimento, instrumento_relatos: @instrumento_relatos
    dado_cadastral "Data", render_data_brasil(atendimento&.data_inicio_verdadeira)
    dado_cadastral "Horário", render_hora_brasil(atendimento&.horario_inicio_verdadeiro)
    dado_cadastral "Status", atendimento&.status
    dado_cadastral "Atividade", atendimento&.tipo

    if atendimento.instrumentos_aplicados.count > 0
      dado_cadastral "Instrumentos aplicados", atendimento.instrumentos_aplicados.map(&:nome).join('; ')
    end

    move_down 12

    markup "<h3><b>Anotações</b></h3>"
    markup markdown_to_html(atendimento&.anotacoes, nil)

    if instrumento_relatos && atendimento.instrumento_relatos.presence
        markup "<h2>Relatos de instrumentos aplicados</h2>", {heading2: {style: :bold, size: 16}}
        atendimento.instrumento_relatos.map do |instrumento_relato|
          markup "<h3>#{instrumento_relato.instrumento.nome}</h3>", {heading3: {style: :italic, size: 14}}
          markup instrumento_relato.dados(nome_instrumento: false, identificação: false).compact.map { |k,v| "<b>#{k.to_s.humanize}</b>: #{v}" }.join("\n<br>\n")
        end
    end
  end


  def dado_atendimento_tabela titulo="", dado=""
    "<tr>" \
      "<th><b>" \
      "#{titulo}" \
      "</b></th>" \
      "<td>" \
      "#{dado}" \
      "</td>" \
      "</tr>"
  end
end
