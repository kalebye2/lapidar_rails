class ProfissionalHorario < ApplicationRecord
  belongs_to :semana_dia
  belongs_to :profissional

  default_scope { order(semana_dia_id: :asc, horario: :asc) }

  def acompanhamento_horarios
    AcompanhamentoHorario.where(horario: horario, semana_dia_id: semana_dia_id)
  end

  def destroy
    ActiveRecord::Base.connection.execute("DELETE FROM profissional_horarios WHERE profissional_id = #{profissional_id} AND semana_dia_id = #{semana_dia_id} AND horario LIKE '%#{horario.strftime("%H:%M:%S")}%'")
  end
end
