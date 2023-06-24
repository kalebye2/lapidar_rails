class PsicologiaSubfuncao < ApplicationRecord
    belongs_to :psicologia_funcao
    has_many :instrumento_subfuncao_juncao
    has_many :instrumento, through: :instrumento_subfuncao_juncao
end
