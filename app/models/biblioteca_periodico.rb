class BibliotecaPeriodico < ApplicationRecord
  has_many :biblioteca_obra, foreign_key: :periodico_id
  has_many :biblioteca_autor, through: :biblioteca_obra

  def obra
    biblioteca_obra
  end

  def autor
    biblioteca_autor
  end
end
