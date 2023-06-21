class Instrumento < ApplicationRecord
  belongs_to :instrumento_tipo
  has_many :psicologia_subfuncao, through: :instrumento_subfuncao_juncoes
end
