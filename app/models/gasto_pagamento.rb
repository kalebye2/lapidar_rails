class GastoPagamento < ApplicationRecord
  belongs_to :gasto
  has_one :gasto_tipo, through: :gasto
end
