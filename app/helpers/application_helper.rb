module ApplicationHelper
  include Pagy::Frontend

  def titulo(titulo)
    # nome do site
    site_name = Rails.application.class.module_parent_name.to_s
    if !titulo.empty?
      content_for :titulo, titulo + " - " + site_name # nome do app
    else
      content_for :titulo, site_name
    end
  end

  def render_data_brasil data
    if data == nil then return data end
    data.strftime("%d/%m/%Y")
  end

  def render_data_extenso data
    if data == nil then return data end
    "#{data.day} de #{t('date.month_names')[data.month].downcase} de #{data.year}"
  end

  def render_hora_brasil hora, zona = nil
    if hora == nil then return nil end
    return hora.strftime("%Hh%M#{zona ? '%z' : ''}")
  end

  def render_dinheiro_centavos valor_em_centavos = 0
    if valor_em_centavos == nil then return nil end
    
    number_to_currency valor_em_centavos.to_f / 100, unit: "R$ ", separator: ",", delimiter: ".", precision: 2
  end

  def render_porcentagem_int porcentagem_int = 0
    if porcentagem_int == nil then return nil end

    "%0.2f%%" % [porcentagem_int / 100]
  end

  def sim_ou_nao valor=false
    !valor.nil? ? valor.to_i > 0 ? "Sim" : "Não" : "Sem informação"
  end

  def markdown_to_html valor, default = "Sem informação"
    valor.nil? ? default : Kramdown::Document.new(valor).to_html
  end

  def markdown valor, default = "Nada"
    valor.nil? ? default : Kramdown::Document.new(valor.to_s).to_kramdown
  end

  def informar valor, default = "Sem informações"
    valor.nil? ? default : valor
  end

  def deixar_no_plural numero, singular='', plural='', se_nulo="Sem informação"
    numero.nil? ? se_nulo : pluralize(numero, singular, plural)
  end

  def numero_com_medida numero, medida = "", default = "Sem informação", casas_decimais: 0
    numero.nil? ? default : "#{number_to_currency(numero, precision: casas_decimais, delimiter: ".", unit: "")}#{medida}"
  end
end
