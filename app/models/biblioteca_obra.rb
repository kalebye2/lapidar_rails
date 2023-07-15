class BibliotecaObra < ApplicationRecord
  belongs_to :biblioteca_editora, optional: true, foreign_key: :editora_id
  belongs_to :biblioteca_obra_tipo, foreign_key: :obra_tipo_id
  belongs_to :biblioteca_obra, foreign_key: :periodico_id, optional: true
  has_many :biblioteca_identificadores, foreign_key: :obra_id
  has_many :biblioteca_obra_autor_juncoes, foreign_key: :obra_id
  has_many :biblioteca_autores, through: :biblioteca_obra_autor_juncoes
  has_many :biblioteca_obra_tag_juncoes, foreign_key: :obra_id
  has_many :biblioteca_tags, through: :biblioteca_obra_tag_juncoes


  def editora
    biblioteca_editora
  end

  def periodico
    biblioteca_periodico
  end

  def autores
    biblioteca_autores
  end

  def autor_juncoes
    biblioteca_obra_autor_juncoes
  end

  def tags
    biblioteca_tags
  end

  def tag_juncoes
    biblioteca_obra_tag_juncoes
  end

  def obra_tipo
    biblioteca_obra_tipo
  end

  def titulo_completo
    if subtitulo.nil?
      titulo
    else
      titulo + ': ' + subtitulo
    end
  end
  # variáveis da classe
end
