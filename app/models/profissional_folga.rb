class ProfissionalFolga < ApplicationRecord
  belongs_to :profissional
  belongs_to :profissional_folga_motivo, optional: true

  alias motivo profissional_folga_motivo
end
