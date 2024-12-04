class ProfissionalFuncao < ApplicationRecord
  has_many :acompanhamento_tipos
  has_many :profissionais

  scope :que_realiza_atendimentos, -> { where(realiza_atendimentos: 1..) }

  def abreviado
    funcao[..2]
  end
end
