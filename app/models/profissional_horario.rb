class ProfissionalHorario < ApplicationRecord
  belongs_to :semana_dia
  belongs_to :profissional

  default_scope { order(semana_dia_id: :asc, horario: :asc) }
end
