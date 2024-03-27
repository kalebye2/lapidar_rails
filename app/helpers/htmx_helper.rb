module HtmxHelper
  # HTMX
  @@keys_to_transform = [:get, :patch, :put, :post, :delete, :confirm, :trigger, :select, :target, :swap, :swap_oob, :replace_url, :include, :on, :push_url, :select_oob, :vals, :boost, :disable, :disable_elt, :disinherit, :encoding, :ext, :headers, :history, :history_elt, :indicator, :params, :preserve, :prompt, :request, :sync, :validate, :vars]
  @@select_opcoes_padrao = [["Escolha", ""], ["Sim", 1], ["Não", 0]]

  def hx_transform dict = {}
    if dict.class.to_s != "Hash" then return {} end

    mkargs = {}

    dict.each do |k,v|
      if k.in?(@@keys_to_transform)
        mkargs["hx-#{h k.to_s.dasherize}"] = dict.delete(k)
      end
    end

    if dict.key? :html_class
      mkargs[:class] = dict.delete :html_class
    end

    mkargs = mkargs.merge(dict)

    mkargs
  end

  def hx_set **kargs
    hx_transform(kargs).map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\"" }.join(' ').html_safe
  end

  def hx_link name = nil, options = nil, **kargs, &block
    hxargs = Hash.new { |k,v| k=>nil }
    verb = kargs[:verb] || :get
    confirm = kargs[:confirm] || "Tem certeza?"
    hxargs = hx_transform(kargs)

    # return [hxargs, kargs]
    prelink = "<a hx-#{verb}=\"#{url_for(name)}\" #{verb.to_s.downcase == "delete" && !confirm.empty? ? "hx-confirm=\"#{h confirm}\"" : ""} href=\"javascript:void(0);\" #{hxargs.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\"" }.join(" ")}>"

    if !block_given?
      # return hxargs.map { |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\"" }.join(" ")
      return "<a hx-#{verb}=\"#{url_for(options)}\" #{verb.to_s.downcase == "delete" && !confirm.empty? ? "hx-confirm=\"#{h confirm}\"" : ""} href=\"javascript:void(0);\" #{hxargs.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\"" }.join(' ')}>#{h name}</a>".html_safe
    end

    "#{prelink}#{capture(&block)}</a>".html_safe
  end

  # formularios ajax HTMX
  def hx_form **kargs, &block
    hxargs = Hash.new { |k,v| k=>nil }
    verb = kargs[:verb] || kargs[:delete].presence || :get
    confirm = kargs[:confirm] || "Tem certeza?"
    hxargs = hx_transform(kargs)

    preform = "<form #{verb.to_s.downcase == "delete" && !confirm.empty? ? "hx-confirm=\"#{h confirm}\"" : ""} #{hxargs.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\"" }.join(" ")}>"
    if !block_given?
      return "<form>"
    end

    "#{preform}#{capture(&block)}</form>".html_safe
  end

  def hx_textarea placeholder: "Descreva...", cols: 50, rows: 10, texto: '', **kargs
    dict = hx_transform kargs
    "<textarea #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(" ")}>#{texto}</textarea>".html_safe
  end

  def hx_input **kargs
    dict = hx_transform kargs
    "#{label.empty? ? '' : "<label for=\"#{name}\">#{label}</label>"}<input type=\"#{type}\" #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(" ")} value=\"#{h value}\">".html_safe
  end

  def hx_text placeholder: "Descreva...", texto: "", value: "", **kargs
    dict = kargs
    "<input type=\"text\" #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(" ")} value=\"#{h value.blank? && !texto.blank? ? texto : value}\">".html_safe
  end

  def hx_number **kargs
    dict = hx_transform kargs
    # "<input type=\"number\" #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(" ")} value=\"#{value}\">"
    "<input type=\"number\" #{dict.map{ |k,v| "#{k.to_s}=\"#{v.to_s}\"" }.join(' ')}>".html_safe
  end

  def hx_select options: [["Sem informação", ""], ["Sim", 1], ["Não", 0]], value: "", blank: false, **kargs
    dict = hx_transform kargs
    options_str = options.map{ |k,v| "<option value=\"#{h v}\" #{v.to_s == value.to_s ? "selected" : ""}>#{h k}</option>"}.join("\n")

    "<select #{dict.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(' ')}>
    #{if blank then "<option value=\"\"></option>" end}
    #{options_str}
    </select>".html_safe
  end

  ## HTMX para formulários em tabela vertical
  def hx_tr_select options: @@select_opcoes_padrao, value: "", blank: false, blank_option: "[Escolha]", html_class: "", th: "", id: "", **kargs
    hx_options = hx_transform kargs
    options_str = options.map{ |k,v| "<option value=\"#{h v}\" #{v.to_s == value.to_s ? "selected" : ""}>#{h k}</option>"}.join("\n")

    "<tr class=\"#{h html_class}\">
    <th>#{h th}</th>
    <td id=\"#{h id}\">
    <select #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(' ')}>
    #{if blank then "<option value=\"\">#{blank_option}</option>" end}
    #{options_str}
    </select>
    </td>
    </tr>".html_safe
  end
  
  # def hx_tr_number id: "", html_class: "", get: "", patch: "", post: "", put: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", number: "", name: "", value: "", th: "", placeholder: ""
  def hx_tr_number id: "", th: "", number: "", value: "", html_class: "", **kargs
    hx_options = hx_transform kargs

    "<tr class=\"#{h html_class}\">
    <th>#{h th}</th>
    <td id=\"#{h id}\">
    <input type=\"number\" value=\"#{value.blank? && !number.blank? ? number : value}\" #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(" ")}>
    </td>
    </tr>".html_safe
  end
  
  def hx_tr_text id: "", html_class: "", texto: "", value: "", th: "", **kargs
    hx_options = hx_transform kargs

    "<tr class=\"#{h html_class}\">
    <th>#{h th}</th>
    <td id=\"#{h id}\">
    <input type=\"text\" value=\"#{value}\" #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(" ")}>
    </td>
    </tr>".html_safe
  end

  # def hx_tr_textarea id: "", html_class: "", get: "", patch: "", post: "", put: "", trigger: "", select: "", target: "", swap: "", swap_oob: "", texto: "", name: "", value: "", th: "", placeholder: "", cols: "50", rows: "10"
  def hx_tr_textarea id: "", html_class: "", texto: "", name: "", value: "", th: "", cols: 50, rows: 10, **kargs
    hx_options = hx_transform kargs

    "<tr #{h html_class} class=\"#{h html_class}\">
    <th>#{h th}</th>
    <td id=\"#{h id}\">
    <textarea name=\"#{name}\" #{hx_options.map{ |k,v| v.to_s.blank? ? "" : "#{h k}=\"#{h v}\""}.join(' ')}>#{texto}</textarea>
    </td>
    </tr>".html_safe
  end

  ## para verificar se a request foi feita por htmx
  def hx_request?
    request.headers["HX-Request"].presence
  end
end
