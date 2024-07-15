class AtendimentoLocal < ApplicationRecord
  belongs_to :atendimento_local_tipo
  belongs_to :pais
  has_many :atendimentos

  scope :publicos, -> { where(publico: true) }
  scope :privados, -> { where(publico: [false, nil]) }

  scope :com_atendimentos_realizados, -> { joins(:atendimentos).distinct }
  scope :sem_atendimentos_realizados, -> { joins("LEFT JOIN atendimentos ON atendimentos.atendimento_local_id = atendimento_locais.id").where(atendimentos: {id: nil}) }

  include Enderecavel

  def tipo
    atendimento_local_tipo.tipo
  end
end
