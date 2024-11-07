class AcompanhamentoDeclaracaoFinalizacaoPdf < BasePdf
  def initialize acompanhamento = Acompanhamento.new
    super
    @acompanhamento = acompanhamento
    header
    move_down 42 * 5
    title
    move_down 28
    body
    local_assinatura @acompanhamento.profissional.descricao_completa.gsub(' - ', "\n")
    footer
  end

  def header
  end

  def title
    font @header_font, style: :bold
    text "Declaração de finalização", align: :center, size: 32, style: :bold
  end

  def body
    font @body_font
    text texto_completo, leading: 5, align: :justify
    move_down 24 * 3
    text local_e_data, align: :center
  end

  def footer
  end

  private

  def texto_completo
    "Declaro que o acompanhamento em " \
      "#{@acompanhamento.tipo.upcase} " \
      "realizado a " \
      "#{@acompanhamento.pessoa.nome_completo.upcase}  " \
      "com início em " \
      "#{@acompanhamento.primeira_data.strftime("%d/%m/%Y")} " \
      "por " \
      "#{@acompanhamento.profissional.descricao_completa.upcase} " \
      "com " \
      "#{contagem = @acompanhamento.atendimentos.realizados.count} #{contagem != 1 ? "atendimentos realizados" : "atendimento realizado"} " \
      "foi finalizado em " \
      "#{@acompanhamento.ultima_data.strftime("%d/%m/%Y")}." \
      ""
  end

  def texto_do_meio
  end

  # def texto_do_meio
  #   os_meses = t('date.month_names')
  #   primeira_data = @acompanhamento.primeiro_atendimento.data
  #   flexao = @acompanhamento.pessoa.no_feminino? ? 'a' : 'o'
  #   if @acompanhamento.acompanhamento_finalizacao_motivo.nil?
  #     if @acompanhamento.pessoa_responsavel.nil?
  #       "está sendo submetid#{flexao} a " \
  #         "#{@acompanhamento.tipo.downcase} sob meus cuidados profissionais desde " \
  #         "#{os_meses[primeira_data.month].downcase} de #{primeira_data.year}."
  #     else
  #       "está sendo submetid#{flexao} a " \
  #         "#{@acompanhamento.tipo.downcase} sob meus cuidados profissionais desde " \
  #         "#{os_meses[primeira_data.month].downcase} de #{primeira_data.year} " \
  #         "com autorização de " \
  #         "#{@acompanhamento.pessoa_responsavel.nome_completo}."
  #     end
  #   else
  #     ultima_data = @acompanhamento.ultimo_atendimento.data
  #     ultima_igual_primeira = ultima_data.month == primeira_data.month && ultima_data.year == primeira_data.year
  #     if @acompanhamento.pessoa_responsavel.nil?
  #       "esteve em acompanhamento em " \
  #         "#{@acompanhamento.tipo.downcase} " \
  #         "sob meus cuidados profissionais #{ultima_igual_primeira ? 'em' : 'de'} " \
  #         "#{os_meses[primeira_data.month].downcase} de #{primeira_data.year}" \
  #         "#{ultima_igual_primeira ? "." : " a #{os_meses[ultima_data.month].downcase} de #{ultima_data.year}."}"
  #     else
  #       "esteve em acompanhamento em " \
  #         "#{@acompanhamento.tipo.downcase} " \
  #         "sob meus cuidados profissionais #{ultima_igual_primeira ? 'em' : 'de'} " \
  #         "#{os_meses[primeira_data.month].downcase} de #{primeira_data.year}" \
  #         "#{ultima_igual_primeira ? " " : " a #{os_meses[ultima_data.month].downcase} de #{ultima_data.year} "}" \
  #         "com autorização de " \
  #         "#{@acompanhamento.pessoa_responsavel.nome_completo}."
  #     end
  #   end
  # end

  def local_e_data
    "#{@acompanhamento.cidade}, " \
      "#{data_por_extenso}"
  end
end
