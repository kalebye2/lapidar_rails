class ProfissionalHorario < ApplicationRecord
  belongs_to :semana_dia
  belongs_to :profissional
  belongs_to :atendimento_local, optional: true
  belongs_to :atendimento_plataforma, optional: true

  default_scope { order(semana_dia_id: :asc, horario: :asc) }

  def acompanhamento_horarios
    AcompanhamentoHorario.where(horario: horario, semana_dia_id: semana_dia_id)
  end

  def destroy
    sqlspecifics = ""
    sqlspecifics += atendimento_local_id ? " AND atendimento_local_id = #{atendimento_local_id}" : " AND atendimento_local_id IS NULL"
    sqlspecifics += atendimento_plataforma_id ? " AND atendimento_plataforma_id = #{atendimento_plataforma_id}" : " AND atendimento_plataforma_id IS NULL"
    ActiveRecord::Base.connection.execute("DELETE FROM profissional_horarios WHERE profissional_id = #{profissional_id} AND semana_dia_id = #{semana_dia_id} AND horario LIKE '%#{horario.strftime("%H:%M:%S")}%' #{sqlspecifics}")
  end

  def default_display
    "#{semana_dia.nome} às #{horario.strftime("%H:%M")} - #{[atendimento_plataforma&.default_display, atendimento_local&.default_display].compact.join(" - ")}"
  end
end
