module ApplicationHelper

  def titulo(titulo)
    if !titulo.empty?
      content_for :titulo, titulo + " - " + Rails.application.class.to_s # nome do app
    else
      content_for :titulo, Rails.application.class.to_s
    end
  end

  def render_data_brasil data
    if data == nil then return data end
    data.strftime("%d/%m/%Y")
  end

  def render_hora_brasil hora, zona = nil
    if hora == nil then return nil end
    return hora.strftime("%Hh%M#{zona ? '%z' : ''}")
  end

  def render_dinheiro_centavos valor_em_centavos = 0
    if valor_em_centavos == nil then return nil end
    
    number_to_currency valor_em_centavos / 100, unit: "R$ ", separator: ",", delimiter: ".", precision: 2
  end

  def render_porcentagem_int porcentagem_int = 0
    if porcentagem_int == nil then return nil end

    "%0.2f%%" % [porcentagem_int / 100]
  end

end
