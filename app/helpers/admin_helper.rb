module AdminHelper
  def path_descriptions
    {
      acompanhamento_finalizacao_motivos: "Motivos de finalização de acompanhamentos",
      atendimento_tipos: "Tipos de atendimento prestados",
      profissional_funcoes: "Funções profissionais",
      civil_estados: "Estados civis",
      atendimento_plataformas: "Plataformas de atendimento",
      atendimento_local_tipos: "Tipos de local de atendimento",
      acompanhamento_tipos: "Tipos de acompanhamento",
      atendimento_modalidades: "Modalidades de atendimento",
      usuarios: "Usuários",
      atendimento_locais: "Locais de atendimento",
    }
  end

  def hx_edit_path table_name, id, edit, value, text: "editar", html_class: ""
    return hx_link "#{text}", admin_root_path(table: table_name, edit: edit, id: id, value: value), class: html_class, select: "##{edit}_#{id}", swap: "outerHTML", target: "##{edit}_#{id}"
  end

  def attribute_edit? id, attribute
    return params[:edit] == attribute&.to_s && params[:id] == id&.to_s
  end

  def display_attribute table_name, id, attribute, value
    final = ""
    value_display = ""
    p_tag = nil
    main_class = Object.const_get(table_name.classify)
    ctype = main_class.column_types[attribute]
    case ctype
    when :string
      value_display = value
    when :integer
      p_tag = "<p style=\"text-align:right;\">"
      if main_class.respond_to?(:metodos_em_reais) && main_class.metodos_em_reais.include?(attribute.to_sym)
        value_display = "#{render_dinheiro_centavos value}"
      else
        value_display = "#{value}\t"
      end
    when :boolean
      p_tag = "<p style=\"text-align:center;\">"
      value_display = value ? check_symbol : cross_symbol
      value_display = sanitize(value_display)
    when :date
      p_tag = "<p style=\"text-align:center;\">"
      value_display = render_data_brasil value
    when :time
      p_tag = "<p style=\"text-align:center;\">"
      value_display = render_hora_brasil value
    when :text
      if value
        value_display = value.length > 100 ? "#{value.split(" ")[..10].join(" ")}..." : value
      end
    else
      value_display = ctype
    end
    # case value.class.to_s
    # when "String"
    #   value_display = value.length > 100 ? "#{value.split(" ")[..20].join(" ")}..." : value
    # when "Integer"
    #   p_tag = "<p style=\"text-align:right;\">"
    #   value_display = "#{value}\t"
    # when "TrueClass"
    #   p_tag = "<p style=\"text-align:center;\">"
    #   value_display = value ? check_symbol : cross_symbol
    #   value_display = sanitize(value_display)
    # when "NilClass"
    # when "Date"
    #   p_tag = "<p style=\"text-align:center;\">"
    #   value_display = render_data_brasil value
    # when "ActiveSupport::TimeWithZone"
    #   p_tag = "<p style=\"text-align:center;\">"
    #   value_display = render_hora_brasil value
    # else
    #   value_display = value.class
    # end
    final += p_tag.to_s
    # final += value_display
    final += hx_edit_path table_name, id, attribute, value.to_s, text: value_display.presence || "+", html_class: value_display.presence ? "" : "button"
    final += p_tag.blank? ? "" : "</p>"
    final.html_safe
  end

  def edit_attribute table_name, id, attribute, value, htmx: false
    id_final = "##{attribute}_#{id}"
    main_class = Object.const_get(table_name.classify)

    if htmx
      hx_form post: admin_update_path(table: table_name, edit: attribute, id: id, authenticity_token: form_authenticity_token.to_s), select: id_final, target: id_final, swap: "outerHTML" do
        input_field_for_attribute(table_name, id, attribute, value, htmx: true)
      end
    else
      input_field_for_attribute(table_name, id_final, attribute, value, htmx: false)
    end
  end

  def edit_attribute_htmx table_name, id, attribute, value
    edit_attribute table_name, id, attribute, value, htmx: true
  end

  def form_final_buttons table_name, id_final
    final = ""
    final += "<input type=\"submit\" value=\"Ok\">"
    final += "<input type=\"button\" value=\"Cancelar\" hx-get=\"#{admin_root_path(table: table_name)}\" hx-select=\"#{id_final}\" hx-target=\"#{id_final}\" hx-swap=\"outerHTML\">"
    final += "<input type=\"reset\" value=\"Redefinir\">"
    final
  end

  def display_assoc table_name, id, attribute, assoc
    final = ""
    inner = ""
    if assoc.class == Array
      assoc = new_assoc_from_attribute(table_name, attribute)
    end
    main_class = Object.const_get(table_name.classify)
    adicionar_text = "+ADICIONAR+"
    adicionar_text = assoc.default_display || adicionar_text
    # adicionar_text = attribute
    inner += hx_edit_path table_name, id, attribute, assoc[assoc.class.primary_key], text: adicionar_text
      # inner += "<br><br>"
      # inner += "<span style=\"font-size:.7em;\">"
      # inner += link_to "Ver classe", admin_root_path(table: assoc.class.to_s.underscore), class: "button"
      # inner += "</span>"
    final += inner
    final.html_safe
  end

  def edit_assoc table_name, id, attribute, assoc, blank_option: "NENHUM", label: "", htmx: false
    # se associação for arranjo e elemento existir
    if assoc.class == Array
      assoc = new_assoc_from_attribute(table_name, attribute)
    end

    main_class = Object.const_get(table_name.classify)
    apkey = assoc[assoc.class.primary_key]
    final_id = "##{attribute}_#{id}"
    param_name = "#{table_name.classify.underscore}[#{attribute}]"

    if htmx
      hx_form post: admin_update_path(table: table_name, id: id, edit: attribute, authenticity_token: form_authenticity_token.to_s), select: final_id, target: final_id, swap: "outerHTML" do
        input_field_for_assoc(table_name, id, attribute, assoc, blank_option: blank_option, label: label, htmx: true)
      end
    else
      input_field_for_assoc(table_name, id, attribute, assoc, blank_option: blank_option, label: label, htmx: false)
    end
  end

  def edit_assoc_htmx table_name, id, attribute, assoc, blank_option: "NENHUM", label: ""
    edit_assoc table_name, id, attribute, assoc, blank_option: blank_option, label: label, htmx: true
  end

  def edit_assoc_new table_name, attribute, blank_option: "NENHUM"
    str = ""
    str += table_name
    str += "\n"
    str += "#{attribute}"
    str
  end

  private

  def new_assoc_from_attribute table_name, attribute
    main_class = Object.const_get(table_name.classify)
    assoc = Object.const_get(main_class.foreign_key_classes[attribute]).new
  end

  def input_field_for_attribute(table_name, id, attribute, value, htmx: false, label: "")
    id_final = "##{attribute}_#{id}"
    param_name = "#{table_name.classify.underscore}[#{attribute}]"

    final = ""
    html_style = {
      "background-color" => "var(--main-color)",
      "color" => "white",
      "padding" => ".3em",
      "width" => "100%",
    }.map { |k,v| "#{k}:#{v}" }.join(";")

    main_class = Object.const_get(table_name.classify)

    valids = main_class.validators_on(attribute).map { |validator|
      validator.class.to_s.include?("Presence") ? "required" :
        validator.class.to_s.include?("Unique") ? "unique" :
        nil
    }
    label_inner = "#{label.presence || attribute} #{valids.join(" ")}"
    final += "<label for=\"#{param_name}\" style=\"#{html_style}\">#{label_inner}</label>"# if main_class.validators_on(attribute).any?
    # case Object.const_get(table_name.classify).column_names[attribute]
    case main_class.column_types[attribute.to_s]
    when :string
      final += "<input type=\"text\" value=\"#{value}\" name=\"#{param_name}\">"
    when :integer
      if main_class.respond_to?(:metodos_em_reais) && main_class.metodos_em_reais.include?(attribute.to_sym)
        money_val = (value / 100.0).to_s.gsub(".", ",")
        final += "<input type=\"text\" value=\"#{money_val}\" name=\"#{param_name}\" data-type=\"currency\">"
      else
        final += "<input type=\"number\" value=\"#{value}\" name=\"#{param_name}\">"
      end
    when :text
      final += "<textarea rows=25 cols=10>"
      final += "#{value}"
      final += "</textarea>"
    when :boolean
      final += "<input name=\"#{param_name}\" type=\"checkbox\" value=\"#{value ? 1 : 0}\" #{"checked" if value}>"
    when :date
      final += "<input type=\"date\" name=\"#{param_name}\" value=\"#{value}\">"
    when :time
      final += "<input type=\"time\" name=\"#{param_name}\" value=\"#{value&.strftime("%H:%M")}\">"
    else
      final += "<input type=\"text\" name=\"#{param_name}\" value=\"#{attribute}\">"
    end
    get_path = admin_root_path(table: table_name)
    # final += hx_link "Ok", admin_update_path(table: table_name, edit: attribute, value: value, id: id, authenticity_token: form_authenticity_token.to_s), verb: :post, class: "button", select: id_final, target: id_final
    if htmx
      final += form_final_buttons table_name, id_final
    end
    # final += hx_link "Cancelar", get_path, verb: :get, select: id_final, swap: "outerHTML", target: id_final, class: "button"
    final.html_safe
  end

  def input_field_for_assoc(table_name, id, attribute, assoc, htmx: false, label: "", blank_option: "NENHUM")
    main_class = Object.const_get(table_name.classify)
    apkey = assoc[assoc.class.primary_key]
    final_id = "##{attribute}_#{id}"
    param_name = "#{table_name.classify.underscore}[#{attribute}]"

    str = ""
    html_style = {
      "background-color" => "var(--main-color)",
      "color" => "white",
      "padding" => ".3em",
      "width" => "100%",
    }.map { |k,v| "#{k}:#{v}" }.join(";")
    valids = main_class.validators_on(main_class.foreign_key_associations[attribute]).map(&:options).map { |h| h[:message] }.compact
    label_inner = "#{label.presence || assoc.class.to_s.underscore} #{main_class.validators_on(main_class.foreign_key_associations[attribute]).map(&:options).map { |h| h[:message] }.join(" ")}"
    str += "<label for=\"#{param_name}\" style=\"#{html_style}\">#{label_inner}</label>"
    str += "<select name=\"#{param_name}\">"
    if main_class.validators_on(main_class.foreign_key_associations[attribute]).map { |validator| validator.class.to_s.index("Presence") }.compact.empty?
      str += "<option value=\"\">#{blank_option}</option>"
    end
    assoc.class.all.each do |element|
      selected = element[assoc.class.primary_key] == apkey
      str += "<option value=\"#{element[assoc.class.primary_key]}\" #{"selected" if selected}>#{element.default_display}</option>"
    end
    str += "</select>"

    if htmx
      str += form_final_buttons table_name, "##{attribute}_#{id}"
    end

    str.html_safe
  end
end
