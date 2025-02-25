class AcompanhamentoReajusteInformativoPdf < BasePdf
  def initialize(acompanhamento_reajuste = AcompanhamentoReajuste.new)
    super
    @acompanhamento_reajuste = acompanhamento_reajuste
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

    # header
    title
    body

    local_assinatura @acompanhamento_reajuste.profissional.descricao_completa.gsub(" - ", "\n")
    footer
  end

  def header
    gerar_cabecalho "Informativo de reajuste - #{@acompanhamento_reajuste.acompanhamento.tipo.upcase} #{@acompanhamento_reajuste.pessoa.nome_completo}"
  end

  def title
    move_down 48
    font @heading_font, style: :bold
    text "Informativo de reajuste", size: 24, align: :center
    font @body_font
  end

  def body
    move_down 100
    markup "<p>Considerando as condições financeiras do atual período" \
      " ficou negociado que o valor para o acompanhamento de" \
      " <b>#{@acompanhamento_reajuste.pessoa&.nome_completo}</b>" \
      " em #{@acompanhamento_reajuste.acompanhamento.tipo.upcase}" \
      ", iniciado em #{render_data_brasil @acompanhamento_reajuste.acompanhamento.data_inicio}," \
      " será ajustado para os atendimentos" \
      " a partir de #{render_data_brasil @acompanhamento_reajuste.data_ajuste}" \
      " no valor de <b>#{render_dinheiro_centavos @acompanhamento_reajuste.valor_novo}</b> por atendimento.</p>" \
      "Agradeço a confiança no meu serviço" \
      " e continuo trabalhando para que a relação" \
      " continue harmoniosa e traga bons resultados." \
      "", @markup_options

    move_down 24 * 3

    text "#{@acompanhamento_reajuste.acompanhamento.cidade}, #{render_data_extenso @acompanhamento_reajuste.data_negociacao}", align: :center
  end

  def footer
    text_box "E-mail: #{@acompanhamento_reajuste.profissional.email}\nFone: #{@acompanhamento_reajuste.profissional.render_fone}", at: [bounds.left, 0], height: 100, width: 1000, size: 10
  end
end
