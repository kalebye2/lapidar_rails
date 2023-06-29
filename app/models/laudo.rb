class Laudo < ApplicationRecord
  belongs_to :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :profissional, through: :acompanhamento

  def paciente
    pessoa
  end
end
