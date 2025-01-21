class Pais < ApplicationRecord
  self.table_name = "paises"
  belongs_to :continente
  has_many :pessoas
  has_many :profissionais, through: :pessoas
  has_many :atendimentos

  def default_display
    nome
  end
end
