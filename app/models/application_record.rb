class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # after_initialize :test

  @atributos_de_templates_publicos = []

  @default_assoc_blank_option = "NENHUM"

  # include ApplicationHelper
  include ActionView::Helpers
  
  MAX_TRIES_RANDOM = 3

  def self.all_tables
    self.base_class.connection.tables
  end

  def self.column_types
    self.columns.map { |column| [column.name, column.type] }.to_h
  end

  # usar primeiras colunas como forma primária de mostrar o valor
  def default_display
    send(self.class.column_names[1])
  end

  def self.associations
    reflect_on_all_associations
  end

  def self.association_names
    # associations.map { |association| [association.foreign_key, association.name] }.to_h
    associations.map { |association| association.name }
  end

  def self.association_keys
    data = associations.map { |association| [association.class.to_s.split("::").last.underscore.split("_")[..-2]&.join("_"), association.foreign_key, association.name] }
    result = {}
    data.map { |atype, fkey, aname| result[atype] = [] }
    data.map { |atype, fkey, aname| result[atype].append({aname => fkey}) }
    result
  end

  def self.association_classes
    associations.map { |association| [association.name, association.options[:class_name].presence ? association.options[:class_name] : association.name.to_s.classify] }.to_h
  end

  def self.foreign_key_classes
    belongs_to_associations.map { |association| [association.foreign_key, association.options[:class_name].presence ? association.options[:class_name] : association.name.to_s.classify] }.to_h
  end

  def self.association_urls
    
  end

  def associations
    self.class.associations.map { |association| self.send(association.name) }
  end

  def association_names
    # self.class.associations.map { |association| [association.foreign_key, association.name] }.to_h
    self.class.association_names
  end

  def association_keys
    self.class.association_keys
  end

  def association_from_foreign_key key
    self.send(association_names[key])
  end

  ["BelongsTo", "HasMany", "HasOne", "HasAndBelongsToMany", "Through"].each do |association_type|
    atype = association_type.underscore
    define_singleton_method "#{atype}_associations" do
      associations.map { |association| association if association.class.to_s.include?(association_type) }.compact
    end

    define_singleton_method "#{atype}_association_names" do
      send("#{atype}_associations").map { |association| association.name }
    end

    define_method "#{atype}_associations" do
      # self.class.send("#{atype}_association_names").map { |association_name| [association_name, send(association_name)] }.to_h
      self.class.send("#{atype}_associations").map {
        |association|
        # [association.name, {foreign_key: association.foreign_key, display: send(association.name)&.default_display, data: send(association.name)}]
        aclass = send(association.name).class.to_s
        if aclass.include?("CollectionProxy")
          [association.name, {foreign_key: association.foreign_key, data: send(association.name)}]
        else
          [association.name, {foreign_key: association.foreign_key, display: send(association.name)&.default_display, data: send(association.name)}]
        end
      }.to_h
    end

    define_method "#{atype}_association_names" do
      self.class.send("#{atype}_association_names")
    end

    define_method "#{atype}_from_foreign_key" do |fk|
      fk = fk.to_s
      data = send("#{atype}_associations")
      data = data.map { |k,v| send(k) if data[k][:foreign_key] == fk }.compact
      data.count == 1 ? data.first : data
    end
  end

  def self.foreign_keys
    belongs_to_associations.map { |association| association.join_foreign_key }
  end

  def self.foreign_key_associations
    belongs_to_associations.map { |association| [association.foreign_key, association.name] }.to_h
  end

  def foreign_keys
    self.class.foreign_keys
  end

  def foreign_key_associations
    self.class.foreign_key_associations
  end

  @app_config = Rails.application.config

  before_create do
    if Rails.application.config.timestamp_id && self.class.primary_key == "id"
      sleep 0.001
      self.id = Time.current.strftime("%s%L").to_i
    end
  end

  require 'csv'

  @@meses = [
    "",
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro",
  ]

  before_save :normalize_blank_values
  
  def normalize_blank_values
    attributes.each do |k,v|
      self[k].present? || self[k] = nil
    end
  end

  def sim_ou_nao(valor = false)
    valor.to_i
  end

  # para localizar um endereço

  def self.concat(*args)
    case Rails.configuration.database_configuration[Rails.env]["adapter"].downcase
    when "mysql"
      "CONCAT(#{args * ', '})"
    when "sqlserver"
      args * ' + '
    else
      args * " || "
    end
  end

  def centificar_numero numero
    valor_final = numero&.to_s || "0,00"

    if !valor_final.include?(",")
      valor_final += ","
    end

    valor_final.gsub!(".", "")
    index_virgula = valor_final.index(",")
    valor_inteiros = valor_final[..index_virgula - 1]
    valor_decimais = ((valor_final[index_virgula + 1..]) + "00")[..1]

    "#{valor_inteiros}#{valor_decimais}".gsub(",", "").to_i
  end
  
  def to_h strftime="%Y-%m-%d"
    attributes.except!("password_digest").map do |k,v|
      if foreign_keys.include?(k)
        assoc = belongs_to_from_foreign_key(k)
        if Array == assoc.class
          [foreign_key_associations[k], assoc.count == 0 ? nil : assoc]
        else
          [foreign_key_associations[k], assoc.default_display]
        end
      else
        case v.class.to_s
        when "Date"
          [k, v.strftime(strftime)]
        else
          [k, v]
        end
      end
    end.to_h
  end

  def self.as_h collection=all
    collection.map { |element| element.to_h }
  end

  def self.como_csv collection=all, col_sep: ",", strftime: "%Y-%m-%d"
    header = column_names.excluding("password_digest").map do |column_name|
      foreign_keys.include?(column_name) ? foreign_key_associations[column_name] : column_name
    end

    data = collection.map { |element| element.to_h.values }

    CSV.generate(col_sep: col_sep) do |csv|
      csv << header
      csv << data
    end

  end
  def self.as_csv collection=all, col_sep: ",", srtrftime: "%Y-%m-%d"
    como_csv collection, col_sep: col_sep, strftime: strftime
  end

  def template_para_dado texto=""
    dados = texto.split("%}").map do |w|
      if w.index("{%")
        word = w[w.index("{%")..].split(/{%\s*/)[-1].split().join(".").downcase
        begin
          value = self.eval(word)
          if value.is_a?(ApplicationRecord) then value = value.default_display end
          if value.is_a?(Float)
            if word.include?("real")
              value = number_to_currency(value, separator: ",", unit: "R$ ", delimiter: ".", precision: 2)
            else
              value = number_to_currency(value, separator: ",", unit: "", delimiter: ".", precision: 2)
            end
          end
          [word, "#{value}"]

        rescue
          [word, nil]
        end
      end
    end
    # dados.compact.to_h
    dados.each { |k,v|
      texto.gsub!(/{%\s*#{k}\s*%}/, v || "")
    }
    texto
    # dados
  end

  def self.class_attributes_as_selectors
    attribute_names.each do |aname|
      define_singleton_method aname do
        select(primary_key, aname)
      end
    end
  end

  def self.instance_public_methods *remove_patterns, default_strings: true
    default_string_patterns = %w[ autosave validate changed = ? build create reload ids debug association csv default_display]
    remove_patterns.map!(&:to_s)
    if default_strings
      remove_patterns.append(*default_string_patterns)
    end

    return instance_methods(false).map { |mname|
      has_pattern = remove_patterns.map { |pattern|
        mname.to_s.index(pattern)
      }.compact.any?
      mname unless has_pattern
    }.compact
  end

  def self.default_assoc_blank_option
    @default_assoc_blank_option
  end

  def self.set_default_assoc_blank_option value
    @default_assoc_blank_option = value.to_s
  end

  def self.as_digraph_html_table header_bg_color: "#cccccc", header_color: "#333333", data_bg_color: "white", data_color: "#333333", table_settings: {border: 0, cellborder: 1, cellspacing: 0}
    "<table id=\"erd_#{table_name}\" #{table_settings.map { |k,v| "#{k}=\"#{v}\"" }.join " "}>
    <tr><td colspan=\"3\" bgcolor=\"#{header_bg_color}\"><b>#{table_name}</b></td></tr>
    #{attribute_names.map { | attr | "<tr><td port=\"#{attr}_in\">#{attr}</td><td>#{column_types[attr]&.upcase}</td><td port=\"#{attr}_out\">#{[("PK" if attr == primary_key), ("FK" if foreign_keys.include? attr)].compact.join " "}</td></tr>"}.join "\n" }
    </table>"
  end
  
  def self.as_digraph_fk_relations
    "
    #{foreign_key_classes.map { |k,v|
    other_class = Object.const_get(v)
    "#{other_class.table_name}:#{other_class.primary_key}_out -> #{table_name}:#{k}_in;"
    }.join "\n"
    }
    "
  end

  def self.all_tables_as_digraph header_bg_color: "#cccccc", header_color: "#333", graph: {splines: :polyline, fontname: :helvetica}, node: {shape: :plaintext, fontname: :helvetica, fontcolor: "#333333"}, edge: {}
    final = "digraph {
    node [#{node.map { |k,v| "#{k}=\"#{v}\"" }.join ";"}];
    rankdir=LR;
    graph [#{graph.map { |k,v| "#{k}=\"#{v}\"" }.join ";"}];
    edge [#{edge.map { |k,v| "#{k}=\"#{v}\"" }.join ";"}];
    "
    Rails.application.eager_load!
    all_models = ApplicationRecord.descendants

    # tables
    all_models.each do |model|
      final += "
      #{model.table_name} [
          label=<
          #{model.as_digraph_html_table}
          >
      ];
      "
    end

    # relations
    all_models.each do |model|
      final += "
      #{model.as_digraph_fk_relations}
      "
    end

    final += "}"
  end

  private

end
