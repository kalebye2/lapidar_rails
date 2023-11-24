module ApplicationHelper
  include Pagy::Frontend

  def titulo(titulo)
    # nome do site
    site_name = Rails.application.class.module_parent_name.to_s
    if !titulo.blank?
      content_for :titulo, titulo + " - " + site_name # nome do app
    else
      content_for :titulo, site_name
    end
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
    valor.nil? ? default : Kramdown::Document.new(valor.to_s).to_html
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

  # markdown

  def markdown_substituir_paragrafo(texto="", substitui_por="")
    texto.to_s.gsub(/\n\n/, substitui_por)
  end

  # HTMX
  def hx_set get: "", patch: "", put: "", post: "", select: "", target: "", swap: "", swap_oob: "", trigger: "", id: "", html_class: "", replace_url: false, confirm: "", delete: "", includes: ""
    {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-delete" => delete,
      "hx-confirm" => confirm,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "swap-oob" => swap_oob,
      id: id,
      class: html_class,
      "hx-replace-url" => replace_url,
      "hx-include" => includes,
    }.map{ |k,v| v.to_s.blank? ? "" : "#{k}=\"#{v}\"" }.join(' ')
  end

  def hx_link body = "Link", url = "", html_options = {}, verb: :get, confirm: "Tem certeza?", &block
    if block_given?
    else
      "<a hx-#{verb}=\"#{url}\" #{verb.to_s.downcase == "delete" && !confirm.empty? ? "hx-confirm=\"#{h confirm}\"" : ""} #{html_options.map { |k,v| "#{k}=\"#{h v}\""}.join(' ')} href=\"javascript:void(0);\">#{h body}</a>"
    end
  end

  # formularios ajax HTMX
  def hx_textarea placeholder: "Descreva...", get: "", patch: "", put: "", post: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", texto: "", cols: "50", rows: "10", name: ""
    dict = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :cols => cols,
      :rows => rows,
      :name => name,
    }
    "<textarea #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{k}=\"#{v}\""}.join(" ")}>#{texto}</textarea>"
  end

  def hx_input placeholder: "", get: "", patch: "", put: "", post: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", name: "", value: "", type: "text", label: "", replace_url: false
    dict = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
      "hx-replace-url" => replace_url,
    }
    "#{label.empty? ? '' : "<label for=\"#{name}\">#{label}</label>"}<input type=\"#{type}\" #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{k}=\"#{v}\""}.join(" ")} value=\"#{h value}\">"
  end

  def hx_text placeholder: "Descreva...", get: "", patch: "", put: "", post: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", texto: "", name: "", value: ""
    dict = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
    }
    "<input type=\"text\" #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{k}=\"#{v}\""}.join(" ")} value=\"#{html_escape value.blank? && !texto.blank? ? texto : value}\">"
  end

  def hx_number placeholder: "Descreva...", get: "", patch: "", put: "", post: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", value: "", name: ""
    dict = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
    }
    "<input type=\"number\" #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{k}=\"#{v}\""}.join(" ")} value=\"#{value}\">"
  end

  def hx_select get: "", patch: "", put: "", post: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", options: [["Sem informação", ""], ["Sim", 1], ["Não", 0]], name: "", value: ""
    dict = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
    }
    options_str = options.map{ |k,v| "<option value=\"#{v}\" #{v.to_s == value.to_s ? "selected" : ""}>#{k}</option>"}.join("\n")
    "<select #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{k}=\"#{v}\""}.join(' ')}>
    #{options_str}
    </select>"
  end

  ## HTMX para formulários em tabela vertical
  def hx_tr_select id: "", html_class: "", get: "", patch: "", post: "", put: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", options: [["Sem informação", ""], ["Sim", 1], ["Não", 0]], name: "", value: "", th: "", blank: false, blank_option: "[Escolha]"
    hx_options = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
    }
    options_str = options.map{ |k,v| "<option value=\"#{v}\" #{v.to_s == value.to_s ? "selected" : ""}>#{k}</option>"}.join("\n")

    "<tr class=\"#{html_escape html_class}\">
    <th>#{html_escape th}</th>
    <td id=\"#{html_escape id}\">
    <select #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{html_escape k}=\"#{html_escape v}\""}.join(' ')}>
    #{if blank then "<option value=\"\">#{blank_option}</option>" end}
    #{options_str}
    </select>
    </td>
    </tr>"
  end
  
  def hx_tr_number id: "", html_class: "", get: "", patch: "", post: "", put: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", number: "", name: "", value: "", th: "", placeholder: ""
    hx_options = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
      :placeholder => placeholder,
    }

    "<tr class=\"#{html_escape html_class}\">
    <th>#{html_escape th}</th>
    <td id=\"#{html_escape id}\">
    <input type=\"number\" value=\"#{value.blank? && !number.blank? ? number : value}\" #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{html_escape k}=\"#{html_escape v}\""}.join(" ")}>
    </td>
    </tr>"
  end
  
  def hx_tr_text id: "", html_class: "", get: "", patch: "", post: "", put: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", texto: "", name: "", value: "", th: "", placeholder: ""
    hx_options = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
      :placeholder => placeholder,
    }

    "<tr class=\"#{html_escape html_class}\">
    <th>#{html_escape th}</th>
    <td id=\"#{html_escape id}\">
    <input type=\"text\" value=\"#{value}\" #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{html_escape k}=\"#{html_escape v}\""}.join(" ")}>
    </td>
    </tr>"
  end

  def hx_tr_textarea id: "", html_class: "", get: "", patch: "", post: "", put: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", texto: "", name: "", value: "", th: "", placeholder: "", cols: "50", rows: "10"
    hx_options = {
      "hx-get" => get,
      "hx-patch" => patch,
      "hx-put" => put,
      "hx-post" => post,
      "hx-trigger" => trigger,
      "hx-select" => select,
      "hx-target" => target,
      "hx-swap" => swap,
      "hx-swap-oob" => swap_oob,
      :name => name,
      :placeholder => placeholder,
      :cols => cols,
      :rows => rows,
    }

    "<tr #{h html_class} class=\"#{h html_class}\">
    <th>#{html_escape th}</th>
    <td id=\"#{html_escape id}\">
    <textarea #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{html_escape k}=\"#{html_escape v}\""}.join(' ')}>#{texto}</textarea>
    </td>
    </tr>"
  end
end
