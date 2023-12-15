class SemanaDia < ApplicationRecord

  def sigla
    nome[0..2]
  end

end
