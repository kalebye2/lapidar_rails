class PessoaInstrumentoRelatosPdf < BasePdf
  def initialize(pessoa = Pessoa.new)
    super()
    @pessoa = pessoa
    @instrumento_relatos = pessoa.instrumento_relatos
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
    header
    title
    body
    number_pages "<page>", at: [bounds.left, 0], align: :center
  end

  def header
    gerar_cabecalho "#{@pessoa.nome_completo} - Aplicações de instrumentos"
  end

  def title
    font @heading_font, style: :bold
    text "#{@pessoa.nome_completo} - Aplicações de instrumentos", size: 36, align: :right
    move_down 36
  end

  def body
    font @body_font
    @instrumento_relatos.each do |instrumento_relato|
      start_new_page
      markup "<h1>#{render_data_brasil instrumento_relato.atendimento.data_inicio_verdadeira}: #{instrumento_relato.instrumento.nome_e_sigla}</h1>"
      dados = instrumento_relato.dados(formato_data: "%d/%m/%Y").compact.except(:nome_instrumento, :sigla_instrumento)
      markup dados.map { |k,v| "<h2>#{k.to_s&.humanize&.upcase}</h2>#{v.instance_of?(Hash) ? v.except(:paciente).compact.map { |k,v| "<p><b>#{k.to_s.humanize}</b>: #{v&.to_s&.upcase}</p>"}.join("\n") : v&.to_s}" }.join("\n")
    end
  end
end
