class PessoaMedicacao < ApplicationRecord
  belongs_to :pessoa

  scope :ate_hoje, -> { where(data_fim: [..Date.current, nil]) }
  scope :a_partir_de_hoje, -> { where(data_inicio: Date.current..) }
  scope :do_periodo, -> (periodo = self.minimum(:data_inicio)..self.maximum(:data_fim)) { where(data_inicio: periodo, data_fim: periodo) }
end
