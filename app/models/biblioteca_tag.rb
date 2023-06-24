class BibliotecaTag < ApplicationRecord
  has_many :biblioteca_obra_tag_juncao, foreign_key: :tag_id
  has_many :biblioteca_obra, through: :biblioteca_obra_tag_juncao

  def obra
    biblioteca_obra
  end
end
