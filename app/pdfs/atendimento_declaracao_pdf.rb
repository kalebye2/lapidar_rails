class AtendimentoDeclaracaoPdf < BasePdf
  def initialize atendimento = Atendimento.new
    super
    @atendimento = atendimento
    header
    move_down 42*5
    title
    move_down 28
    body
    local_assinatura @atendimento.profissional.descricao_completa.gsub(" - ", "\n")
    footer
  end

  def header
  end

  def title
    font @header_font, style: :bold
    text "Declaração", align: :center, size: 32, style: :bold
  end

  def body
    font @body_font
    text "" \
      "Declaro para fins de comprovação que " \
      "#{@atendimento.pessoa.nome_completo} " \
      "esteve presente em atendimento em " \
      "#{@atendimento.tipo.downcase} " \
      "no dia #{@atendimento.data_inicio_verdadeira.strftime("%d/%m/%Y")} " \
      "das #{@atendimento.horario_inicio_verdadeiro.strftime("%Hh%M")} às #{@atendimento.horario_fim_verdadeiro.strftime("%Hh%M")}." \
      "", leading: 5, align: :justify
    move_down 24 * 3
    text local_e_data, align: :center
  end

  def footer
  end

  private

  def local_e_data
    "#{@atendimento.cidade}, " \
      "#{data_por_extenso}."
  end
end
