module Monetizavel
  extend self

  @@em_reais = []

  def self.de_centavos_pra_real *args
    args.each do |arg|
      method_name = "#{arg}_real".to_sym
      @@em_reais << arg

      define_method method_name do
        if self.respond_to?(arg)
          self.send(arg) / 100.0
        elsif ApplicationRecord.descendants.include?(self)
          case self.column_types[arg.to_s]
          when :integer
            self.sum(arg) / 100.0
          else
            self.column_types[arg]
          end
        else
          nil
        end
      end
    end
  end

  def metodos_em_reais
    @@em_reais
  end

  def metodos_decompostaveis *args
    args.each do |arg|
      method_name = "#{arg}_decomposto".to_sym
      if self.respond_to?(arg)
        decompor(arg)
      elsif ApplicationRecord.descendants.include?(self)
      end
    end
  end

  def self.decompor valor
    valor_decomposto = {}
    if self.respond_to?(arg)
      valor_str = self.send(arg).to_s || "0,00"
      valor_str += "," unless valor_str.include?(",")
      valor_str.gsub!(".", "")
      index_virgula = valor_str.index(",")
      valor_decomposto[:inteiros] = valor_str[..index_virgula - 1]
      valor_decomposto[:decimais] = ((valor_str[index_virgula + 1..]) + "00")[..1]
      valor_decomposto
    end
  end

  def self.compor valor
  end
end
