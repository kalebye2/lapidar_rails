class Atendimento < ApplicationRecord
  require 'csv'

  belongs_to :acompanhamento, inverse_of: :atendimentos
  belongs_to :atendimento_local, inverse_of: :atendimentos, optional: true
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id, inverse_of: :atendimentos
  has_one :profissional, through: :acompanhamento

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento
  has_one :atendimento_reagendamento, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento
  has_many :instrumento_relatos
  has_many :instrumentos, through: :instrumento_relatos
  alias instrumentos_aplicados instrumentos
  has_one :infantojuvenil_anamnese
  has_one :adulto_anamnese

  accepts_nested_attributes_for :atendimento_valor, update_only: true
  accepts_nested_attributes_for :instrumento_relatos, update_only: true

  # scopes
  default_scope { includes(:acompanhamento, :atendimento_tipo, :atendimento_modalidade, :atendimento_local) }

  scope :realizados, -> { where(presenca: true) }
  scope :nao_realizados, -> { where(presenca: [false, nil]) }
  scope :futuros, -> { where(data: [Date.today + 1.day..]).or(self.where(data: Date.today, horario: [Time.now.beginning_of_hour - 3.hour..])).or(self.where(data_reagendamento: Date.today, horario_reagendamento: [Time.now.beginning_of_hour - 3.hour..])).or(self.where(data_reagendamento: [Date.today + 1.day..])) }
  scope :passados, -> { where(data: [..Date.today]) }

  scope :do_periodo, -> (periodo = Atendimento.minimum(:data)..Atendimento.maximum(:data), ordem = :asc) { where(data: periodo).order(data: ordem, horario: ordem) }
  scope :ate_hoje, -> { where(data: ..Date.today).or(self.where(data_reagendamento: ..Date.today)) }
  scope :ate_agora, -> { where(id: map{ |atendimento| if atendimento.horario_passado then atendimento.id end }.compact) }
  scope :reagendados_ate_hoje, -> { where(data_reagendamento: ..Date.today) }
  scope :de_hoje, -> (ordem = :asc) { where(data: Date.today).order(horario: ordem, horario_reagendamento: ordem) }
  scope :reagendados_de_hoje, -> (ordem = :asc) { where(data_reagendamento: Date.today).em_ordem(ordem) }
  scope :da_semana, -> (semana: Date.today.all_week, ordem_data: :asc, ordem_horario: :asc) { where(data: semana).em_ordem }
  scope :desta_semana, -> { da_semana }
  scope :da_semana_passada, -> { da_semana semana: (Date.today - 1.week).all_week }
  scope :reagendados_da_semana, -> (semana: Date.today.all_week, ordem_data: :asc, ordem_horario: :asc) { where(data_reagendamento: semana).em_ordem(ordem_data) }
  scope :do_mes_atual, -> { where(data: Date.today.all_month).em_ordem }
  scope :reagendados_do_mes_atual, -> { where(data_reagendamento: Date.today.all_month).em_ordem }
  scope :deste_mes, -> { do_mes_atual }
  scope :reagendados_deste_mes, -> { reagendados_do_mes_atual }
  scope :do_mes_passado, -> { where(data: (Date.today - 1.month).all_month).em_ordem }
  scope :reagendados_do_mes_passado, -> { where(data_reagendamento: (Date.today - 1.month).all_month).em_ordem }
  scope :do_ano_atual, -> { where(data: Date.today.all_year) }
  scope :reagendados_do_ano_atual, -> { where(data_reagendamento: Date.today.all_year) }
  scope :deste_ano, -> { do_ano_atual }
  scope :reagendados_deste_ano, -> { reagendados_do_ano_atual }
  scope :do_ano_passado, -> { where(data: (Date.today - 1.year).all_year).em_ordem }
  scope :reagendados_do_ano_passado, -> { where(data_reagendamento: (Date.today - 1.year).all_year).em_ordem }
  scope :reagendados, -> { where.not(data_reagendamento: nil) }

  # ordenados
  scope :em_ordem, -> (ordem = :asc) { order(data: ordem, horario: ordem, data_reagendamento: ordem, horario_reagendamento: ordem) }

  scope :sem_anotacoes, -> { where(anotacoes: [nil, ""]) }
  scope :com_anotacoes, -> { where.not(anotacoes: [nil, ""]) }

  scope :sem_local_definido, -> { where(atendimento_local: nil) }

  scope :de_menores_de_idade, -> { joins(:acompanhamento).where(acompanhamento: {menor_de_idade: true}) }
  scope :de_maiores_de_idade, -> { joins(:acompanhamento).where(acompanhamento: {menor_de_idade: [false, nil]}) }

  # agrupamentos
  scope :contagem_por_dia, -> (periodo = "1900-01-01".."2999-12-31") { where(data: periodo).group(:data).count }
  scope :contagem_por_mes, -> (periodo = "1900-01-01".."2999-12-31") { contagem_por_dia(periodo).group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| {k.to_date.all_month=>v.count} } }
  scope :contagem_por_profissional, -> { joins(:profissional).group("profissionais.id").count.map { |k,v| {Profissional.find(k) => v} } }
  scope :contagem_por_tipo, -> (tipos = AtendimentoTipo.all) { where(atendimento_tipo: tipos).group(:atendimento_tipo).count }
  scope :contagem_por_pessoa, -> (pessoas = Pessoa.all) { joins(:acompanhamento).where(acompanhamentos: { pessoa: pessoas }).group("acompanhamentos.pessoa_id").count.map { |k,v| {Pessoa.find(k) => v} } }
  scope :contagem_por_local, -> (locais = AtendimentoLocal.all) { where(atendimento_local: locais).group(:atendimento_local).count }
  # scope :contagem_por_profissional_e_pessoa, -> (profissionais = Profissional.all, pessoas = Pessoa.all) { joins(:acompanhamento).where(acompanhamentos: { profissional: profissionais, pessoa: pessoas }).group("acompanhamentos.profissional_id, acompanhamentos.pessoa_id").count }

  scope :query_like_tipo, -> (like) { where(atendimento_tipo: AtendimentoTipo.where("LOWER(tipo) LIKE '%#{like}%'")) }

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
  alias pessoa_responsavel responsavel

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

  def informacoes incluir_pessoa: true, incluir_profissional: true, **kwargs
    
  end

  def informacoes_com_pessoa
    "#{pessoa.nome_completo} - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def informacoes_sem_pessoa
   "#{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}" 
  end

  def informacoes_confidencial
    p = pessoa
    "#{p.nome_confidencial}
    - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def reagendado
    !data_reagendamento.nil? || horario_reagendamento.nil?
  end
  alias reagendado? reagendado

  def horario_inicio_verdadeiro
    horario_reagendamento || horario
  end

  def horario_fim_verdadeiro
    horario_reagendamento_fim || horario_fim || horario_inicio_verdadeiro + 1.hour
  end

  def horario_periodo_verdadeiro sep='até', format="%Hh%M"
    "#{horario_inicio_verdadeiro.strftime(format)}" \
      " #{sep} " \
      "#{horario_fim_verdadeiro.strftime(format)}" \
      ""
  end
  
  def horario_periodo sep='até', format="%Hh%M"
    "#{horario.strftime(format)}" \
      " #{sep} " \
      "#{horario_final.strftime(format)}" \
      ""
  end

  def horario_periodo_reagendado sep='até', format="%Hh%M"
    "#{horario_reagendado.strftime(format)}" \
      " #{sep} " \
      "#{horario_fim_reagendado.strftime(format)}" \
      ""
  end

  def data_inicio_verdadeira
    data_reagendamento || data
  end

  def data_fim_verdadeira
    data_reagendamento_fim || data_fim || data_reagendamento || data
  end

  def horario_passado
    d = data_fim_verdadeira
    h = horario_fim_verdadeiro
    dh = h.change(day: d.day, month: d.month, year: d.year)
    dh.past?
    # data_inicio_verdadeira < Date.today || (data_inicio_verdadeira == Date.today && horario_fim_verdadeiro < t)
    # if !horario_reagendamento.nil?
    #   return data < Date.today || (data == Date.today && horario_reagendamento_fim < Time.now)
    # end
    # if !horario.nil?
    #   data < Date.today || (data == Date.today && horario_final < Time.now)
    # end
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
    (horario_fim_verdadeiro.nil? ? horario_inicio_verdadeiro + 1.hour : horario_fim_verdadeiro).strftime("%H:%M").to_time
  end

  def horario_inicial
    horario.strftime("%H:%M").to_time
  end

  def no_futuro
    d = data_fim_verdadeira
    h = horario_fim_verdadeiro
    dh = h.change(day: d.day, month: d.month, year: d.year)
    dh.future?
    # if !horario.nil?
    #   data > Date.today || (data == Date.today && horario_final > Time.now.hour)
    # end
  end

  def status
    #pessoa_presente ? "Realizado" : horario_passado ? "Não realizado" : em_andamento ? "Em andamento" : em_breve ? "Em breve" : "A ocorrer"
    horario_passado ? pessoa_presente ? "Realizado" : "Não realizado" : em_breve ? "Em breve" : no_horario ? pessoa_presente ? "Em andamento": "Na hora": "A ocorrer"
  end

  def em_breve
    if !horario_inicio_verdadeiro.nil?
      data_inicio_verdadeira == Date.today && horario_inicio_verdadeiro.hour == Time.now.hour + 1
    end
  end

  def em_breve_ou_em_andamento
    em_breve || em_andamento
  end

  def local padrao_nulo="-"
    atendimento_local.nil? ? padrao_nulo : atendimento_local.descricao
  end

  def reagendado?
    !data_reagendamento.nil?
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

  def para_csv
    "" \
      "\"#{paciente.nome_completo}\"," \
      "\"#{paciente.render_sexo}\"," \
      "\"#{profissional.descricao_completa}\"," \
      "\"#{pessoa_responsavel&.nome_completo}\"," \
      "\"#{tipo.upcase}\"," \
      "\"#{data}\"," \
      "\"#{horario.strftime("%H:%M:%S")}\"," \
      "\"#{horario_final&.strftime("%H:%M:%S")}\"," \
      "\"#{data_reagendamento}\"," \
      "\"#{horario_reagendamento&.strftime("%H:%M:%S")}\"," \
      "\"#{horario_reagendamento_fim&.strftime("%H:%M:%S")}\"," \
      "\"#{status.upcase}\"," \
      ""
  end

  def dados_do_atendimento incluir_profissional = false
    {
      profissional: incluir_profissional ? profissional.descricao_completa : nil,
      data: data_inicio_verdadeira.strftime("%d/%m/%Y"),
      horário: horario_inicio_verdadeiro.strftime("%H:%M"),
      reagendado: reagendado? ? "Sim" : nil,
      status: status,
      atividade: tipo,
      modalidade: modalidade,
      instrumentos_usados: instrumentos_aplicados.map(&:nome).join(", ").presence,
      anotações: Kramdown::Document.new(anotacoes.to_s).to_html.presence,
      avanços: Kramdown::Document.new(avancos.to_s).to_html.presence,
      limitações: Kramdown::Document.new(limitacoes.to_s).to_html.presence,
    }
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

  def self.para_csv collection = all
    # "" \
    #   "PACIENTE,SEXO,PROFISSIONAL,RESPONSÁVEL LEGAL,TIPO,DATA,HORÁRIO," \
    #   "HORÁRIO FIM,DATA REAGENDADA,HORÁRIO REAGENDADO,HORÁRIO REAGENDADO FIM,STATUS," \
    #   "\n" \
    #   "#{collection.each.map(&:para_csv).join("\n")}" \
    #   ""
    CSV.generate(col_sep: ',') do |csv|
      csv << [
        "PACIENTE",
        "SEXO",
        "PROFISSIONAL",
        "RESPONSÁVEL LEGAL",
        "TIPO",
        "DATA",
        "HORÁRIO",
        "HORÁRIO FIM",
        "DATA REAGENDADA",
        "HORÁRIO REAGENDADO",
        "HORÁRIO REAGENDADO FIM",
        "STATUS",
      ]
      collection.each do |a|
        csv << [
          a.pessoa.nome_completo,
          a.pessoa.render_sexo,
          a.profissional.descricao_completa,
          a.pessoa_responsavel&.nome_completo,
          a.tipo,
          a.data.strftime("%d/%m/%Y"),
          a.horario.strftime("%H:%M"),
          a.horario_fim&.strftime("%H:%M"),
          a.data_reagendamento&.strftime("%d/%m/%Y"),
          a.horario_reagendamento&.strftime("%H:%M"),
          a.horario_reagendamento_fim&.strftime("%H:%M"),
          a.status,
        ]
      end
    end
  end
end
