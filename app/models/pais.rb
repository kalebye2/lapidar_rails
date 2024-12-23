class Pais < ApplicationRecord
  self.table_name = "paises"
  belongs_to :continente

  def default_display
    nome
  end
end
