class ProfissionalFolga < ApplicationRecord
  belongs_to :profissional
  belongs_to :profissional_folga_motivo, optional: true

  scope :com_inicio_no_periodo, -> (periodo=Date.current.all_year) { where data_inicio: periodo }
  scope :com_fim_no_periodo, -> (periodo=Date.current.all_year) { where data_final: periodo }
  scope :do_periodo, -> (periodo=Date.current.all_year) { com_inicio_no_periodo.or com_fim_no_periodo }
  
  scope :do_profissional, -> (profissional = nil) { where profissional: profissional }
  scope :do_profissional_com_id, -> (id = nil) { where profissional_id: id }

  scope :do_motivo, -> (motivo = nil) { where profissional_folga_motivo: motivo }
  scope :do_motivo_com_id, -> (id = nil) { where profissional_folga_motivo_id: id }

  alias motivo profissional_folga_motivo

  def motivo
    profissional_folga_motivo&.motivo
  end
end
