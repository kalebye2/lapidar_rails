class Continente < ApplicationRecord
  has_many :paises
  has_many :pessoas, through: :paises
  has_many :atendimentos, through: :paises
end
