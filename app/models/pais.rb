class Pais < ApplicationRecord
  self.table_name = "paises"
  belongs_to :continente
end
