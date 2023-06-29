class Gasto < ApplicationRecord
  belongs_to :gasto_tipo, optional: true
  has_many :gasto_pagamentos
end
