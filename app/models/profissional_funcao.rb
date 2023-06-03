class ProfissionalFuncao < ApplicationRecord

  def abreviado
    funcao[..2]
  end

end
