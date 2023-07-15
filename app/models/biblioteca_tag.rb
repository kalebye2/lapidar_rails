class BibliotecaTag < ApplicationRecord
  has_many :biblioteca_obra_tag_juncoes, foreign_key: :tag_id
  has_many :biblioteca_obras, through: :biblioteca_obra_tag_juncoes

  def obra
    biblioteca_obra
  end

  def obra_juncao
    biblioteca_obra_tag_juncao
  end
end
