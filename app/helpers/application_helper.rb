module ApplicationHelper
  include Pagy::Frontend

  @@site_name = Rails.application.config.app_name || Rails.application.class.module_parent_name.to_s
  @@config = Rails.application.config

  def titulo(titulo)
    # nome do site
    site_name = Rails.application.config.app_name || Rails.application.class.module_parent_name.to_s
    content_for :titulo, [titulo.presence, @@site_name].compact.join(" | ")
  end

  def nome_do_site
    @@site_name
  end

  def titulo_da_aplicacao
    site_name = Rails.application.config.app_name || Rails.application.class.module_parent_name.to_s
  end

  def app_config
    @@config
  end

  def nome_da_clinica
    @@config.clinica_nome
  end

  def render_tempo_meses_resumido(tempo_meses = 0)
    if tempo_meses.class.to_s != "Integer" then return "Não é possível calcular tempo" end
    if tempo_meses % 12 == 0
      "#{pluralize(tempo_meses / 12, "ano", "anos")}"
    else
      tempo_meses > 12 ? "#{pluralize(tempo_meses / 12, "ano", "anos")} e #{pluralize(tempo_meses % 12, "mês", "meses")}" : pluralize(tempo_meses, "mês", "meses")
    end
  end

  def render_data_brasil data
    if data == nil then return data end
    data.strftime("%d/%m/%Y")
  end

  def render_data_periodo_brasil data1, data2=nil, sep=" a "
    return data1 if data1.blank?
    "#{data1.strftime("%d/%m/%Y")}#{data2&.strftime("%d/%m/%Y")&.insert(0, sep) unless data2 == data1}"
  end

  def render_data_extenso data
    if data == nil then return data end
    "#{data.day} de #{t('date.month_names')[data.month].downcase} de #{data.year}"
  end
  alias render_data_por_extenso render_data_extenso

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

    # "%0.2f%%" % [porcentagem_int / 100]
    number_to_percentage porcentagem_int / 100, precision: 2, delimiter: ".", separator: ","
  end

  def sim_ou_nao valor=false, fallback = ""
    if valor.class.name == "TrueClass"
      valor ? "Sim" : "Não"
    else
      !valor.nil? ? valor.to_i > 0 ? "Sim" : "Não" : fallback
    end
  end

  def calcular_tempo data1, data2 = Date.current, default=""
    if data1 == nil || data1.class.to_s != "Date" then return "data não informada" end
    if data2.class.to_s != "Date" then return "" end
    ultima_data = data2
    #ultima_data = Date.parse '1996-11-07'


    ultima_data_ano = ultima_data.year
    ultima_data_mes = ultima_data.month
    ultima_data_dia = ultima_data.day

    data1_ano = data1.year
    data1_mes = data1.month
    data1_dia = data1.day

    # agora para os calculos
    dia_dif = ultima_data_dia - data1_dia
    mes_dif = ultima_data_mes - data1_mes
    ano_dif = ultima_data_ano - data1_ano

    #return "# #{mes_dif} #{ano_dif}"
    # se a diferença é menor que um mês
    if data2 - data1 < data1.end_of_month.day
      return pluralize (data2 - data1).to_i, 'dia', 'dias'
    end

    # data1ido no mesmo ano que ultima_data
    if ano_dif == 0
      plural = mes_dif == 1 ? "mês" : "meses"
      return "#{ultima_data_mes - data1_mes} #{plural}"
    end

    # data1ido no mesmo mês que ultima_data
    if mes_dif == 0
      dia_me = dia_dif >= 0
      anos_passados = dia_me ? ano_dif : ano_dif - 1
      plural_anos = anos_passados == 1 ? "" : "s"
      tem_meses = !dia_me ? " e 11 meses" : ""
      return "#{anos_passados} ano#{plural_anos}#{tem_meses}"
    end

    # agora o bicho vai pegar
    meses_passados = mes_dif < 0 ? 12 + mes_dif : mes_dif
    dias_passados = dia_dif >= 0
    meses_passados = dias_passados ? meses_passados : meses_passados - 1
    anos_passados = mes_dif > 0 ? ano_dif : ano_dif - 1

    plural_anos = anos_passados == 1 ? "ano" : "anos"
    # plural_meses = meses_passados == 1 ? "mês" : "meses"
    plural_meses = meses_passados == 1 ? "mês" : "meses"
    tem_meses = meses_passados > 0 ? " e #{meses_passados} #{plural_meses}" : ""

    return "#{ano_dif} #{plural_anos}#{tem_meses}"

    return default
  end

  def informar valor, default = "Sem informações"
    valor.nil? ? default : valor
  end

  def deixar_no_plural numero, singular='', plural='', se_nulo="Sem informação"
    numero.nil? ? se_nulo : pluralize(numero, singular, plural)
  end

  def numero_com_medida numero, medida = "", default = "Sem informação", casas_decimais: 0
    numero.nil? ? default : "#{number_to_currency(numero, precision: casas_decimais, delimiter: ".", unit: "", separator: ",")}#{medida}"
  end

  def data_por_extenso data=Date.current
    return nil if data.class.to_s != "Date"
    "#{data.day} de #{t('date.month_names')[data.month].downcase} de #{data.year}"
  end

  def montar_sentenca
  end

  def inputs_de_ate de = Date.current, ate = Date.current, label_de: "de", label_ate: "ate"
    "
    <label for=\"#{label_de}\">De</label>
    <input type=\"date\" name=\"#{label_de}\" id=\"#{label_de}\" value=\"#{de}\">
    <label for=\"#{label_ate}\">Até</label>
    <input type=\"date\" name=\"#{label_ate}\" id=\"#{label_ate}\" value=\"#{ate}\">
    ".html_safe
  end

  def navegador_paginas_simples
  end

  def navegador_carregar_mais_paginas
  end
end
