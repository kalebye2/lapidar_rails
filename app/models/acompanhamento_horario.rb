class AcompanhamentoHorario < ApplicationRecord
  belongs_to :acompanhamento
  belongs_to :semana_dia
  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  default_scope { order(semana_dia_id: :asc, horario: :asc, acompanhamento_id: :asc) }

  scope :de_acompanhamentos_em_andamento, -> { joins(:acompanhamento).where(acompanhamento: { acompanhamento_finalizacao_motivo: nil }) }


  def descricao
    "#{semana_dia.nome.upcase} - #{horario.strftime("%H:%M")}#{horario_fim.nil? ? "" : " às #{horario_fim.strftime("%H:%M")}"}"
  end

  def descricao_resumida
    "#{semana_dia.sigla.upcase} #{horario.strftime("%H:%M")}#{horario_fim.nil? ? "" : "-#{horario_fim.strftime("%H:%M")}"}"
  end

  def destroy
    print "HAHAHA"
    ActiveRecord::Base.connection.execute("DELETE FROM acompanhamento_horarios WHERE acompanhamento_id = #{acompanhamento_id} AND semana_dia_id = #{semana_dia_id} AND horario = '#{horario}' AND horario_fim #{horario_fim.nil? ? "IS NULL" : " = '#{horario_fim}'"};")
  end

end
