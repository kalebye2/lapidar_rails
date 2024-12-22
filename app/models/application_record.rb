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
    associations.map { |association| [association.foreign_key, association.name] }.to_h
  end

  def self.association_urls
    
  end

  def associations
    self.class.associations.map { |association| self.send(association.name) }
  end

  def association_names
    self.class.associations.map { |association| [association.foreign_key, association.name] }.to_h
  end

  def association_from_foreign_key key
    self.send(association_names[key])
  end

  ["BelongsTo", "HasMany", "HasOne", "HasAndBelongsToMany", "Through"].each do |association_type|
    define_singleton_method "#{association_type.underscore}_associations" do
      associations.map { |association| association if association.class.to_s.include?(association_type) }.compact
    end

    define_singleton_method "#{association_type.underscore}_names" do
      send("#{association_type.underscore}_associations").map { |association| association.name }
    end

    define_method "#{association_type.underscore}_associations" do
      self.class.send("#{association_type.underscore}_names").map { |association_name| [association_name, send(association_name)] }.to_h
    end
  end

  def self.foreign_keys
    belongs_to_associations.map { |association| association.join_foreign_key }
  end

  def foreign_keys
    self.class.foreign_keys
  end

  @app_config = Rails.application.config

  before_create do
    if Rails.application.config.timestamp_id && self.class.primary_key == "id"
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

  def self.como_csv collection=all, col_sep: ","
    CSV.generate(col_sep: col_sep) do |csv|
      csv << attribute_names
      collection.each do |record|
        csv << record.attributes.values
      end
    end
  end
end
