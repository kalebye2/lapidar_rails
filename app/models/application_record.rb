class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_initialize :test

  # include ApplicationHelper
  include ActionView::Helpers
  
  MAX_TRIES_RANDOM = 3

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
