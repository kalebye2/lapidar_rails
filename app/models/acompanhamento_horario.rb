class AcompanhamentoHorario < ApplicationRecord

  attr_accessor :tempo_duracao_minutos

  before_save do
    self.tempo_duracao_segundos = tempo_duracao_minutos.to_i * 60 if tempo_duracao_minutos
  end

  belongs_to :acompanhamento
  belongs_to :semana_dia
  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  default_scope { order(semana_dia_id: :asc, horario: :asc, acompanhamento_id: :asc) }

  scope :de_acompanhamentos_em_andamento, -> { joins(:acompanhamento).where(acompanhamento: Acompanhamento.em_andamento ) }


  def descricao
    # "#{semana_dia.nome.upcase} - #{horario.strftime("%H:%M")}#{horario_fim.nil? ? "" : " às #{horario_fim.strftime("%H:%M")}"}"
    "#{semana_dia.nome.upcase} - #{horario.strftime("%H:%M")} às #{horario + tempo_duracao_segundos.seconds}"
  end

  def descricao_resumida
    # "#{semana_dia.sigla.upcase} #{horario.strftime("%H:%M")}#{horario_fim.nil? ? "" : "-#{horario_fim.strftime("%H:%M")}"}"
    "#{semana_dia.sigla.upcase} #{horario.strftime("%H:%M")}-#{(horario + tempo_duracao_segundos.seconds).strftime("%H:%M")}"
  end

  def destroy
    ActiveRecord::Base.connection.execute("DELETE FROM acompanhamento_horarios WHERE acompanhamento_id = #{acompanhamento_id} AND semana_dia_id = #{semana_dia_id} AND horario LIKE '%#{horario.strftime("%H:%M:%S")}%' AND tempo_duracao_segundos = #{tempo_duracao_segundos}")
  end

  def profissional_horario
    ProfissionalHorario.where(horario: horario, semana_dia_id: semana_dia_id).first
  end

end
