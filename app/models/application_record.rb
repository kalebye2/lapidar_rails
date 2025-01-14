class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_initialize :test

  # include ApplicationHelper
  include ActionView::Helpers
  
  MAX_TRIES_RANDOM = 3

  def self.all_tables
    self.base_class.connection.tables
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

  def test
    
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

end
