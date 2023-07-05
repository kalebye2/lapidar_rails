class BibliotecaEditora < ApplicationRecord
  has_many :biblioteca_obras, foreign_key: :editora_id
  has_many :biblioteca_autores, through: :biblioteca_obra

  def obra
    biblioteca_obra
  end

  def autor
    biblioteca_autor
  end
end
