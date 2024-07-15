class PessoaMedicacao < ApplicationRecord
  belongs_to :pessoa

  scope :ate_hoje, -> { where(data_fim: [..Date.current, nil]) }
  scope :a_partir_de_hoje, -> { where(data_inicio: Date.current..) }
  scope :do_periodo, -> (periodo = self.minimum(:data_inicio)..self.maximum(:data_fim)) { where(data_inicio: periodo, data_fim: periodo) }
  scope :descontinuadas, -> { where(data_fim: ..Date.current) }
  scope :em_andamento, -> { where(data_fim: [Date.current.., nil]) }

  def descricao_completa
    "#{descricao}#{periodo&.insert(0, " [")&.insert(-1, "]") unless periodo.blank?}"
  end

  def descricao
    "#{medicacao}#{dose&.insert(0, " (")&.insert(-1, ")")}#{motivo&.insert(0, " - ")}"
  end

  def periodo formato="%d/%m/%Y", separador="-"
    if data_inicio
      "#{data_inicio&.strftime(formato)}#{data_fim&.strftime(formato)&.insert(0, separador)}"
    else
      "#{data_fim&.strftime(formato)&.insert(0, "..")}"
    end
  end
end
