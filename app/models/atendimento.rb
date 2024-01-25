class Atendimento < ApplicationRecord
  belongs_to :acompanhamento, inverse_of: :atendimentos
  belongs_to :atendimento_local, inverse_of: :atendimentos, optional: true
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id, inverse_of: :atendimentos

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento
  has_many :instrumento_relatos
  has_many :instrumentos, through: :instrumento_relatos
  alias instrumentos_aplicados instrumentos
  has_one :infantojuvenil_anamnese

  accepts_nested_attributes_for :atendimento_valor, update_only: true
  accepts_nested_attributes_for :instrumento_relatos, update_only: true

  # scopes
  default_scope { includes(:acompanhamento, :atendimento_tipo, :atendimento_modalidade, :atendimento_local) }

  scope :realizados, -> { where(presenca: true) }
  scope :nao_realizados, -> { where(presenca: [false, nil]) }
  scope :futuros, -> { where(data: [Date.today + 1.day..]).or(self.where(data: Date.today, horario: [Time.now.beginning_of_hour - 3.hour..])) }
  scope :do_periodo, -> (periodo = Atendimento.minimum(:data)..Atendimento.maximum(:data), ordem = :asc) { where(data: periodo).order(data: ordem, horario: ordem) }
  scope :ate_hoje, -> { where(data: ..Date.today) }
  scope :de_hoje, -> (ordem = :asc) { where(data: Date.today).order(horario: ordem) }
  scope :da_semana, -> (semana: Date.today.all_week, ordem_data: :asc, ordem_horario: :asc) { where(data: semana).order(data: ordem_data, horario: ordem_horario) }
  scope :do_mes_atual, -> { where(data: Date.today.all_month) }
  scope :deste_mes, -> { do_mes_atual }
  scope :do_mes_passado, -> { where(data: (Date.today - 1.month).all_month) }
  scope :do_ano_atual, -> { where(data: Date.today.all_year) }
  scope :deste_ano, -> { do_ano_atual }
  scope :do_ano_passado, -> { where(data: (Date.today - 1.year).all_year) }
  scope :reagendados, -> { where(reagendado: true) }
  # ordenados
  scope :em_ordem, -> (ordem = :asc) { order(data: ordem, horario: ordem) }
  scope :sem_anotacoes, -> { where(anotacoes: [nil, ""]) }
  scope :com_anotacoes, -> { where.not(anotacoes: [nil, ""]) }

  # agrupamentos
  scope :contagem_por_dia, -> (de: Atendimento.minimum(:data), ate: Atendimento.maximum(:data)) { where(data: de..ate).group(:data).count }
  scope :contagem_por_mes, -> (de: Atendimento.minimum(:data), ate: Atendimento.maximum(:data)) { where(data: de..ate).group(:data).count }
  scope :contagem_por_profissional, -> { group(:profissional).count }

  def consideracoes
    anotacoes
  end
  
  # pessoas envolvidas
  def pessoa
    acompanhamento.pessoa
  end
  alias paciente pessoa

  def profissional
    acompanhamento.profissional
  end

  def responsavel
    acompanhamento.pessoa_responsavel
  end

  def acompanhamento_tipo
    acompanhamento.acompanhamento_tipo.tipo
  end


  # the resto
  def pessoa_presente
    return presenca
  end

  def pessoa_presente_desc
    pessoa_presente ? "Presente" : "Ausente"
  end

  def modalidade
    atendimento_modalidade.modalidade
  end

  def tipo
    atendimento_tipo.tipo.upcase
  end

  def informacoes_com_pessoa
    "#{acompanhamento.pessoa.nome_completo} - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def informacoes_sem_pessoa
   "#{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}" 
  end

  def informacoes_confidencial
    p = acompanhamento.pessoa
    "#{p.nome_confidencial}
    - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def horario_passado
    if !horario.nil?
      data < Date.today || (data == Date.today && horario_final < Time.now)
    end
  end

  def em_andamento
    if !horario.nil?
      data == Date.today && horario_inicial < Time.now && horario_final > Time.now && pessoa_presente
    end
  end

  def no_horario
    if !horario.nil?
      data == Date.today && horario_inicial < Time.now && horario_final > Time.now
    end
  end

  def horario_final
    (horario_fim.nil? ? horario + 1.hour : horario_fim).strftime("%H:%M").to_time
  end

  def horario_inicial
    horario.strftime("%H:%M").to_time
  end

  def no_futuro
    if !horario.nil?
      data > Date.today || (data == Date.today && horario_final > Time.now.hour)
    end
  end

  def status
    #pessoa_presente ? "Realizado" : horario_passado ? "Não realizado" : em_andamento ? "Em andamento" : em_breve ? "Em breve" : "A ocorrer"
    horario_passado ? pessoa_presente ? "Realizado" : "Não realizado" : em_breve ? "Em breve" : no_horario ? pessoa_presente ? "Em andamento": "Na hora": "A ocorrer"
  end

  def em_breve
    if !horario.nil?
      data == Date.today && horario.hour == Time.now.hour + 1
    end
  end

  def em_breve_ou_em_andamento
    em_breve || em_andamento
  end

  def local
    atendimento_local.nil? ? "Não definido" : atendimento_local.descricao
  end

  # como evento de calendário
  def evento_ics
    "BEGIN:VEVENT" \
      "\n" \
      "SUMMARY:#{tipo.downcase.capitalize} - #{paciente.nome_completo}" \
      "\n" \
      "DTSTAMP:#{Time.now.strftime("%Y%m%dT%H%M%SZ")}" \
      "\n" \
      "DTSTART:#{data.strftime("%Y%m%d")}T#{horario.strftime("%H%M%S")}Z" \
      "\n" \
      "DTEND:#{(data_fim || data).strftime("%Y%m%d")}T#{(horario_fim || horario).strftime("%H%M%S")}Z" \
      "\n" \
      "LOCATION:#{local}" \
      "\n" \
      "ORGANIZER: #{profissional.descricao_completa}" \
      "\n" \
      "STATUS: #{status.upcase}" \
      "\n" \
      "UID:#{data.strftime("%Y%m%d")}#{horario.strftime("%H%M%S")}#{tipo.upcase.gsub(/\s/, '')}#{paciente.nome_completo.upcase.gsub(/\s/, '')}#{id}" \
      "\n" \
      "END:VEVENT" \
      ""
  end

  def self.calendario_ics(collection: all)
    "BEGIN:VCALENDAR" \
      "\n" \
      "VERSION:2.0" \
      "\n" \
      "#{collection.map(&:evento_ics).join('')}" \
      "\n" \
      "END:VCALENDAR"
  end
end
