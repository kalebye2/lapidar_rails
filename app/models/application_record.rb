class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_initialize :test
  
  MAX_TRIES_RANDOM = 3

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

  def para_csv propriedades=[]
    propriedades.map { |p| "\"#{p}\"" }.join(',') + "\n"
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

  def self.aleatorio num_try = 0
    begin
      order("RANDOM()").first
    rescue ActiveRecord::RecordNotFound
      if num_try > MAX_TRIES_RANDOM
        first
      else
        aleatorio num_try + 1
      end
    rescue Exception
      raise
    end
  end

  def self.aleatorios num_records = 1, num_try = 0
    begin
      order("RANDOM()").limit(num_records)
    rescue Exception
      raise
    end
  end

  def self.random_group num_records = 1
    aleatorios num_records
  end

  def self.random
    aleatorio
  end

  def self.para_csv collection=all,header=[]
    CSV.generate(col_sep: ',') do |csv|
      csv << header
      collection.each do |c|
        csv << c.para_csv
      end
    end
  end
end
