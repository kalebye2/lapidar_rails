class AcompanhamentoDetalhesPdf < BasePdf
  def initialize acompanhamento = Acompanhamento.new
    super
    @acompanhamento = acompanhamento
    header
    title
    move_down 7
    body
    local_assinatura @acompanhamento.profissional.descricao_completa.gsub(' - ', "\n")
    footer
  end

  def header
  end

  def title
    font @heading_font, style: :bold
    text "Prontuário #{@acompanhamento.profissional.profissional_funcao.adjetivo_masc}", size: 24, align: :center
  end

  def body
    font @body_font
    dados_cadastrais
    font @heading_font, style: :bold
    move_down 24
    markup "<h1>Registros dos atendimentos</h1>"
    font @body_font
    @acompanhamento.atendimentos.each_with_index do |atendimento, index|
      move_down 12
      font @heading_font, style: :bold
      markup "<h2>Sessão #{index + 1}</h2>"
      font @body_font
      dados_atendimento atendimento
    end
  end

  def footer
  end

  private

  def dados_cadastrais
    dado_cadastral "Nome do paciente", @acompanhamento.paciente.nome_completo
    dado_cadastral "Data de nascimento", render_data_brasil(@acompanhamento.paciente.data_nascimento)
    dado_cadastral "Idade", @acompanhamento.paciente.render_idade
    dado_cadastral "Sexo", @acompanhamento.paciente.render_sexo
    dado_cadastral "Estado civil", @acompanhamento.paciente.estado_civil
    dado_cadastral "Grau de instrucao", @acompanhamento.paciente.grau_de_instrucao
    dado_cadastral "Profissão", @acompanhamento.paciente.profissao || "Não informada"
    dado_cadastral "Fone", @acompanhamento.paciente.render_fone
    dado_cadastral "E-mail", "<a href='mailto:#{@acompanhamento.paciente.email}'>#{@acompanhamento.paciente.email}</a>"
    dado_cadastral "Contato para emergência", @acompanhamento.pessoa_responsavel.presence ? "#{@acompanhamento.pessoa_responsavel.nome_completo} - <a href='tel:#{@acompanhamento.pessoa_responsavel.render_fone_link}'>#{(@acompanhamento.pessoa_responsavel.render_fone)}</a>" : "inserir contato para emergência"
    # TODO RG
    dado_cadastral "CPF", @acompanhamento.paciente.render_cpf
    dado_cadastral "Endereço", "#{@acompanhamento.paciente.render_endereco} - #{@acompanhamento.paciente.estado}/#{@acompanhamento.paciente.pais.nome}"
    # TODO toma medicação
    dado_cadastral "Motivo da consulta", @acompanhamento.motivo
    # TODO hipótese diagnóstica
    # TODO objetivo do acompanhamento
    dado_cadastral "Início do acompanhamento", render_data_brasil(@acompanhamento.primeiro_atendimento.data)
    # dado_cadastral "Status", @acompanhamento.status
    move_down 12
    horizontal_rule
    move_down 12
    dado_cadastral "#{@acompanhamento.profissional.funcao}", @acompanhamento.profissional.descricao_completa
    dado_cadastral "Assinatura"
  end

  def dado_cadastral titulo="", texto=""
    markup "<b>#{titulo}</b>: #{texto&.to_s&.upcase}"
  end

  def dados_atendimento atendimento
    # dado_cadastral "Data", render_data_brasil(atendimento&.data)
    # dado_cadastral "Horário", render_hora_brasil(atendimento&.horario)
    # dado_cadastral "Status", atendimento&.status
    # dado_cadastral "Atividade", atendimento&.tipo
    # markup markdown_to_html("### Anotações\n\n")
    markup \
      "<table>" \
      "<tbody>" \
      "#{dado_atendimento_tabela "Data", render_data_brasil(atendimento.data)}" \
      "#{dado_atendimento_tabela "Horário", render_hora_brasil(atendimento.horario)}" \
      "#{dado_atendimento_tabela "Status", atendimento.status}" \
      "#{dado_atendimento_tabela "Atividade", atendimento.tipo.upcase}" \
      "#{dado_atendimento_tabela "Anotações", markdown_to_html(atendimento.anotacoes)}" \
      "</tbody>" \
      "</table>"
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
