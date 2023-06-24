class BibliotecaObra < ApplicationRecord
  belongs_to :biblioteca_editora, optional: true, foreign_key: :editora_id
  belongs_to :biblioteca_obra_tipo, foreign_key: :obra_tipo_id
  belongs_to :biblioteca_obra, foreign_key: :periodico_id, optional: true
  has_many :biblioteca_identificador, foreign_key: :obra_id
  has_many :biblioteca_obra_autor_juncao, foreign_key: :obra_id
  has_many :biblioteca_autor, through: :biblioteca_obra_autor_juncao
  has_many :biblioteca_obra_tag_juncao, foreign_key: :obra_id
  has_many :biblioteca_tag, through: :biblioteca_obra_tag_juncao


  def editora
    biblioteca_editora
  end

  def periodico
    biblioteca_periodico
  end

  def autor
    biblioteca_autor
  end

  def autor_juncao
    biblioteca_obra_autor_juncao
  end

  def tag
    biblioteca_tag
  end

  def tag_juncao
    biblioteca_obra_tag_juncao
  end

  def obra_tipo
    biblioteca_obra_tipo
  end

  # variáveis da classe
end
