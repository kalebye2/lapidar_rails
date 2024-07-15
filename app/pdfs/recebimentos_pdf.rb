class RecebimentosPdf < BasePdf
  def initialize(collection=Recebimento.all)
    super(page_layout: :landscape, margin: [70, 30, 70, 30])
    @recebimentos = collection
    header
    body
    footer
  end

  def header
    gerar_cabecalho "Relatório de recebimentos - #{render_data_periodo_brasil @recebimentos.minimum(:data), @recebimentos.maximum(:data)}"
  end

  def body
    titulo
    font @body_font, size: 6
    markup "#{gerar_tabela}"
  end

  def gerar_tabela
    "<table>
    <thead>
    <tr>
    #{@recebimentos.first&.dados.map { |k,v| "<th>#{k&.to_s&.humanize&.upcase}</th>" }.join ""}
    </tr>
    </thead>
    <tbody>
    #{@recebimentos.map(&:dados).map { |recebimento| dados_tabela(recebimento) }.join " "}
    </tbody>
    </table>"
  end

  def dados_tabela(dados={})
    dados[:valor] = render_dinheiro_centavos dados[:valor]
    "<tr>#{dados.map { |k,v| "<td>#{v&.upcase}</td>" }.join "\n"}</tr>"
  end

  def titulo
    font @heading_font, style: :bold
    text "Recebimentos de #{render_data_periodo_brasil @recebimentos.minimum(:data), @recebimentos.maximum(:data)}", size: 24, align: :center
    move_down 14
  end

  def footer
  end
end
