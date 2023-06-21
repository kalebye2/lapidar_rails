class PsicologiaFuncao < ApplicationRecord
  has_many :psicologia_subfuncao, inverse_of: :psicologia_funcao
end
