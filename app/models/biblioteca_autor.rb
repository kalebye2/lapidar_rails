class BibliotecaAutor < ApplicationRecord
  has_many :biblioteca_obra_autor_juncoes, foreign_key: :autor_id
  has_many :biblioteca_obras, through: :biblioteca_obra_autor_juncoes
  has_many :biblioteca_tags, through: :biblioteca_obra

  def obra
    biblioteca_obra
  end

  def obra_juncao
    biblioteca_obra_autor_juncoes
  end

  def tag
    biblioteca_tag
  end
end
