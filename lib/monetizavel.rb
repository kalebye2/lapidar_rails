module Monetizavel
  extend self

  def self.de_centavos_pra_real *args
    args.each do |arg|
      define_method "#{arg}_real" do
        self.send(arg) / 100.0
      end
    end
  end

end
