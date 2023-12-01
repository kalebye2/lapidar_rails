class ProfissionalFuncao < ApplicationRecord

  scope :que_realiza_atendimentos, -> { where(realiza_atendimentos: 1..) }

  def abreviado
    funcao[..2]
  end

end
