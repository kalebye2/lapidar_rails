class Instrumento < ApplicationRecord
  belongs_to :instrumento_tipo
  has_many :instrumento_subfuncao_juncao
  has_many :psicologia_subfuncao, through: :instrumento_subfuncao_juncao

  has_many :instrumento_relatos

  def relatos
    instrumento_relatos
  end
end
