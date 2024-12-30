class ProfissionalFolga < ApplicationRecord
  belongs_to :profissional
  belongs_to :profissional_folga_motivo, optional: true

  scope :com_inicio_no_periodo, -> (periodo=Date.current.all_year) { where data_inicio: periodo }
  scope :com_fim_no_periodo, -> (periodo=Date.current.all_year) { where data_final: periodo }
  # folgas que iniciam ou terminam num determinado período
  scope :do_periodo, -> (periodo=Date.current.all_year) { com_inicio_no_periodo(periodo..periodo).or com_fim_no_periodo(periodo..periodo) }
  # folgas que estão contidas num determinado período
  scope :no_periodo, -> (periodo=Date.current.all_year) {
    case periodo.class.to_s
    when "Range"
      where(data_inicio: ..periodo.last, data_final: periodo.first..)
    when "Date"
      where(data_final: periodo.., data_inicio: ..periodo)
    else
      nil
    end
  }
  scope :em_andamento, -> (data=Date.current) { where(data_final: data.., data_inicio: ..data) }
  scope :futuras, -> { where(data_inicio: Date.current..) }
  scope :passadas, -> { where(data_final: ..Date.current) }
  
  scope :do_profissional, -> (profissional = nil) { where profissional: profissional }
  scope :do_profissional_com_id, -> (id = nil) { where profissional_id: id }

  scope :do_motivo, -> (motivo = nil) { where profissional_folga_motivo: motivo }
  scope :do_motivo_com_id, -> (id = nil) { where profissional_folga_motivo_id: id }

  alias motivo profissional_folga_motivo

  def motivo
    profissional_folga_motivo&.motivo
  end
end
