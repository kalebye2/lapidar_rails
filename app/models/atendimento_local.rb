class AtendimentoLocal < ApplicationRecord
  belongs_to :atendimento_local_tipo
  belongs_to :pais
  has_many :atendimentos

  scope :publicos, -> { where(publico: true) }
  scope :privados, -> { where(publico: [false, nil]) }

  include Enderecavel

  def tipo
    atendimento_local_tipo.tipo
  end
end
