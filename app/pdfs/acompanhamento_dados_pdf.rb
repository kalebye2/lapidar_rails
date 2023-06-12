class AcompanhamentoDadosPdf < BasePdf

  def initialize(acompanhamento = Acompanhamento.new)
    super()
    @acompanhamento = acompanhamento
    heading
    move_down 7
    stroke_horizontal_rule
    move_down 10
    body
  end

  def heading
    font @heading_font
    text "FICHA DE ACOMPANHAMENTO", style: :bold, align: :right
    move_down 7
    text @acompanhamento.tipo.upcase, style: :bold
    move_down 7
    text "#{@acompanhamento.pessoa.nome_completo} #{@acompanhamento.pessoa.render_sexo_sigla}", style: :bold, size: 30
    move_down 7
    text "#{@acompanhamento.profissional.nome_completo} #{@acompanhamento.profissional.documento}", style: :bold
  end

  def body
    font @body_font, size: 16
    if @acompanhamento.pessoa_responsavel
      text 'Responsável legal: ' + @acompanhamento.pessoa_responsavel.nome_completo
    end
    text 'Motivo do acompanhamento: ' + @acompanhamento.motivo
    text 'Início em: ' + @acompanhamento.data_inicio.strftime("%d/%m/%Y")
    text 'Quantidade de sessões: ' + @acompanhamento.atendimento.count.to_s
    text 'Sessões atendidas: ' + @acompanhamento.atendimento.where(presenca: true).count.to_s
    text 'Valor da sessão: ' + helpers.number_to_currency(@acompanhamento.valor_atual.to_f / 100, unit: "R$ ", separator: ",", delimiter: ".", precision: 2)
  end

  def helpers
    ActionController::Base.helpers
  end

end
