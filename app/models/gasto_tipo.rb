class GastoTipo < ApplicationRecord
  has_many :gastos
  has_many :gasto_pagamentos, through: :gastos
end
