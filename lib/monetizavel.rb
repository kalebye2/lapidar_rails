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
end
