class AcompanhamentoContratoPdf < BasePdf
  def initialize(model=[Acompanhamento.new, ProfissionalContratoModelo.new], page_size: "A4", options: {})
    super(page_size: page_size.upcase)
    @acompanhamento = model.first
    @profissional_contrato_modelo = model.last
    @options = options
    gerar_cabecalho "#{@profissional_contrato_modelo.titulo}"
    move_down 30

    title
    default_leading 10
    move_down 10
    body
    footer
  end

  def title
    font @heading_font, style: :bold
    text "#{@profissional_contrato_modelo.titulo}", size: 24, align: :center
    move_down 30
  end

  def body
    markup markdown_to_html(@profissional_contrato_modelo.conteudo_para_acompanhamento @acompanhamento), text: {align: :justify}, heading1: {size: 24, style: :bold}
  end

  def footer
    if @options[:assinatura_paciente].presence
      local_assinatura @acompanhamento.paciente.nome_completo
    end
    if @options[:assinatura_responsavel].presence && @acompanhamento.pessoa_responsavel
      local_assinatura @acompanhamento.pessoa_responsavel.nome_completo
    end
    if @options[:assinatura_profissional].presence
      local_assinatura @acompanhamento.profissional.descricao_completa.gsub(" - ", "\n")
    end
  end
end
