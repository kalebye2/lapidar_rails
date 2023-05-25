class Usuario < ApplicationRecord
  belongs_to :pessoa

  has_many :acompanhamento
end
