class PsicologiaFuncao < ApplicationRecord
  has_many :psicologia_subfuncoes, inverse_of: :psicologia_funcao
end
