class Instrumento < ApplicationRecord
  belongs_to :instrumento_tipo
  has_many :instrumento_subfuncao_juncoes
  has_many :psicologia_subfuncoes, through: :instrumento_subfuncao_juncoes

  scope :por_nome, -> (nome) { where("LOWER(nome) LIKE LOWER('%#{nome}%')") }

  has_many :instrumento_relatos

  def relatos
    instrumento_relatos
  end
end
