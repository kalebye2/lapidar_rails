class Atendimento < ApplicationRecord
  require 'csv'

  belongs_to :acompanhamento, inverse_of: :atendimentos
  belongs_to :atendimento_local, inverse_of: :atendimentos, optional: true
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id, inverse_of: :atendimentos
  has_one :profissional, through: :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :pessoa_responsavel, through: :acompanhamento

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento
  has_one :atendimento_reagendamento, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento
  has_many :instrumento_relatos
  has_many :instrumentos, through: :instrumento_relatos
  alias instrumentos_aplicados instrumentos
  alias instrumentos_usados instrumentos
  has_one :infantojuvenil_anamnese
  has_one :adulto_anamnese

  accepts_nested_attributes_for :atendimento_valor, update_only: true
  accepts_nested_attributes_for :instrumento_relatos, update_only: true

  # scopes
  default_scope { includes(:acompanhamento, :atendimento_tipo, :atendimento_modalidade, :atendimento_local) }

  scope :realizados, -> { where(presenca: true) }
  scope :nao_realizados, -> { where(presenca: [false, nil]) }
  scope :futuros, -> { where(data: Date.current + 1.day..).or(self.where(data: Date.current, horario: Time.current..)).or(self.where(data_reagendamento: Date.current, horario_reagendamento: [Time.current..])).or(self.where(data_reagendamento: [Date.current + 1.day..])) }
  scope :passados, -> { where(data: Date.current, horario: ..Time.current).or(self.where data_reagendamento: Date.current, horario: ..Time.current).or(self.where data: ..Date.current - 1.day).or(self.where data_reagendamento: ..Date.current - 1.day) }
  # scope :a_ocorrer, -> { where("COALESCE(data_reagendamento, data) > CURRENT_DATE").or self.where("COALESCE(data_reagendamento, data) >= CURRENT_DATE AND COALESCE(horario_reagendamento, horario) > CURRENT_TIME") }

  scope :do_periodo, -> (periodo = Atendimento.minimum(:data)..Atendimento.maximum(:data)) { where(data: periodo).or(self.where(data_reagendamento: periodo)) }
  scope :ate_hoje, -> { where(data: ..Date.current).or(self.where(data_reagendamento: ..Date.current)) }
  scope :ate_agora, -> { where(id: map{ |atendimento| if atendimento.horario_passado then atendimento.id end }.compact) }
  scope :ate_ontem, -> () { do_periodo(..Date.yesterday) }
  scope :reagendados_ate_hoje, -> { where(data_reagendamento: ..Date.current) }
  scope :de_hoje, -> () { where(data: Date.current) }
  scope :reagendados_de_hoje, -> () { where(data_reagendamento: Date.current) }
  scope :de_hoje_com_reagendados, -> () { where(data: Date.current).or(self.where data_reagendamento: Date.current) }
  scope :da_semana, -> (semana: Date.current.all_week) { where(data: semana) }
  scope :desta_semana, -> { da_semana }
  scope :da_semana_passada, -> { da_semana semana: (Date.current - 1.week).all_week }
  scope :reagendados_da_semana, -> (semana: Date.current.all_week) { where(data_reagendamento: semana) }
  scope :do_mes_atual, -> { where(data: Date.current.all_month) }
  scope :reagendados_do_mes_atual, -> { where(data_reagendamento: Date.current.all_month) }
  scope :deste_mes, -> { do_mes_atual }
  scope :reagendados_deste_mes, -> { reagendados_do_mes_atual }
  scope :do_mes_passado, -> { where(data: (Date.current - 1.month).all_month) }
  scope :reagendados_do_mes_passado, -> { where(data_reagendamento: (Date.current - 1.month).all_month) }
  scope :do_ano_atual, -> { where(data: Date.current.all_year) }
  scope :reagendados_do_ano_atual, -> { where(data_reagendamento: Date.current.all_year) }
  scope :deste_ano, -> { do_ano_atual }
  scope :reagendados_deste_ano, -> { reagendados_do_ano_atual }
  scope :do_ano_passado, -> { where(data: (Date.current - 1.year).all_year) }
  scope :reagendados_do_ano_passado, -> { where(data_reagendamento: (Date.current - 1.year).all_year) }
  scope :reagendados, -> { where.not(data_reagendamento: nil) }

  # ordenados
  scope :em_ordem, -> (ordem = :asc) { order(data: ordem, horario: ordem, data_reagendamento: ordem, horario_reagendamento: ordem) }
  scope :em_ordem_considerando_reagendamentos, -> (ordem = :asc) { em_ordem.sort_by(&:data_inicio_verdadeira) }

  scope :sem_anotacoes, -> { where(anotacoes: [nil, ""]) }
  scope :com_anotacoes, -> { where.not(anotacoes: [nil, ""]) }

  scope :sem_local_definido, -> { where(atendimento_local: nil) }
  scope :com_local_definido, -> { where.not(atendimento_local: nil) }
  scope :dos_locais, -> (atendimento_local = AtendimentoLocal.all) do
    relation = group(atendimento_local: atendimento_local)
    relation.count
  end

  scope :de_menores_de_idade, -> { joins(:acompanhamento).where(acompanhamento: {menor_de_idade: true}) }
  scope :de_maiores_de_idade, -> { joins(:acompanhamento).where(acompanhamento: {menor_de_idade: [false, nil]}) }

  # acompanhamento
  scope :de_acompanhamentos_em_andamento, -> { where acompanhamento: {acompanhamento_finalizacao_motivo: nil} }
  scope :de_acompanhamentos_finalizados, -> { where.not acompanhamento: {acompanhamento_finalizacao_motivo: nil} }

  # agrupamentos
  scope :contagem_por_dia, -> do
    relation = group(:data)
    relation.count
  end
  scope :contagem_por_mes, -> do
    contagem_por_dia.group_by { |k,v| k.strftime("%m/%Y") }.map { |k,v| [k.to_date.all_month, v.map(&:last).sum] }.to_h
  end
  scope :contagem_por_ano, -> do
    contagem_por_dia.group_by { |k,v| k.strftime("%Y") }.map { |k,v| [k, v.map(&:last).sum] }.to_h
  end
  scope :contagem_por_profissional, -> (profissionais = Profissional.all, ordem = nil) do
    relation = joins(:acompanhamento).group(:profissional_id)
    if ordem != nil
      relation = relation.order(count_id: ordem)
    end
    relation.count.map { |k,v| [Profissional.find(k), v] }.to_h
  end
  scope :contagem_por_tipo, -> (tipos = AtendimentoTipo.all, ordem = nil) do
    relation = where(atendimento_tipo: tipos).group(:atendimento_tipo)
    if ordem != nil
      relation = relation.order(count_id: ordem)
    end
    relation.count
  end
  scope :contagem_por_pessoa, -> (pessoas = Pessoa.all, ordem = nil) do
    relation = joins(:acompanhamento).where(acompanhamentos: { pessoa: pessoas }).group(:pessoa_id)
    if ordem != nil
      relation = relation.order(count_id: ordem)
    end
    relation.count.map { |k,v| [Pessoa.find(k), v] }.to_h
  end
  scope :contagem_por_local, -> { group(:atendimento_local).count }
  # scope :contagem_por_profissional_e_pessoa, -> (profissionais = Profissional.all, pessoas = Pessoa.all) { joins(:acompanhamento).where(acompanhamentos: { profissional: profissionais, pessoa: pessoas }).group("acompanhamentos.profissional_id, acompanhamentos.pessoa_id").count }

  scope :query_like_tipo, -> (like) { where(atendimento_tipo: AtendimentoTipo.where("LOWER(tipo) LIKE '%#{like}%'")) }
  scope :do_tipo, -> (tipo) { where(atendimento_tipo: tipo) }
  scope :do_tipo_com_id, -> (id) { where(atendimento_tipo_id: id) }
  scope :da_pessoa, -> (pessoa) { joins(:acompanhamento).where(acompanhamento: {pessoa: pessoa}) }
  scope :da_pessoa_com_id, -> (id) { joins(:acompanhamento).where(acompanhamento: {pessoa_id: id}) }
  scope :do_acompanhamento, -> (acompanhamento) { where(acompanhamento: acompanhamento) }
  scope :do_acompanhamento_com_id, -> (id) { where(acompanhamento_id: id) }

  scope :query_pessoa_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(pessoas.nome || ' ' || COALESCE(pessoas.nome_do_meio, '') || ' '|| pessoas.sobrenome) LIKE ?", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(pessoas.nome, ' ', COALESCE(pessoas.nome_do_meio, ''), ' ', pessoas.sobrenome)) LIKE ?", "%#{like}%"
    end
    joins(:pessoa).where(query)
  end
  scope :query_responsavel_like_nome, -> (like = "") do
    like = like.to_s
    query = "LOWER(responsaveis.nome || ' ' || COALESCE(responsaveis.nome_do_meio, '') || ' '|| responsaveis.sobrenome) LIKE ?", "%#{like}%"
    if Rails.configuration.database_configuration[Rails.env]["adapter"].downcase == "mysql"
      query = "LOWER(CONCAT(responsaveis.nome, ' ', COALESCE(responsaveis.nome_do_meio, ''), ' ', responsaveis.sobrenome)) LIKE ?", "%#{like}%"
    end
    joins("JOIN pessoas AS responsaveis ON responsaveis.id = acompanhamentos.pessoa_responsavel_id").where(query)
  end

  scope :valor, -> { joins(:atendimento_valor).sum(:valor) }

  def consideracoes
    anotacoes
  end
  
  # pessoas envolvidas
  alias paciente pessoa

  alias responsavel pessoa_responsavel

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
  end

  def em_andamento
    if !horario.nil?
      data == Date.current && horario_inicial < Time.current && horario_final > Time.current && pessoa_presente
    end
  end

  def no_horario
    data_inicio_verdadeira == Date.current && horario_inicial < Time.current && horario_final > Time.current
  end

  def horario_final
    (horario_fim_verdadeiro || horario_inicio_verdadeiro + 1.hour).strftime("%H:%M").to_time
  end

  def horario_inicial
    horario_inicio_verdadeiro.strftime("%H:%M").to_time
  end

  def no_futuro
    d = data_fim_verdadeira
    h = horario_fim_verdadeiro
    dh = h.change(day: d.day, month: d.month, year: d.year)
    dh.future?
    # if !horario.nil?
    #   data > Date.current || (data == Date.current && horario_final > Time.current.hour)
    # end
  end

  def status
    #pessoa_presente ? "Realizado" : horario_passado ? "Não realizado" : em_andamento ? "Em andamento" : em_breve ? "Em breve" : "A ocorrer"
    horario_passado ? pessoa_presente ? "Realizado" : "Não realizado" : em_breve ? "Em breve" : no_horario ? pessoa_presente ? "Em andamento": "Na hora": "A ocorrer"
  end

  def em_breve
    if !horario_inicio_verdadeiro.nil?
      data_inicio_verdadeira == Date.current && horario_inicio_verdadeiro.hour == Time.current.hour + 1
    end
  end

  def em_breve_ou_em_andamento
    em_breve || em_andamento
  end

  def local padrao_nulo="-"
    atendimento_local.nil? ? padrao_nulo : atendimento_local.descricao
  end

  def cidade padrao_nulo="Brasília"
    atendimento_local&.endereco_cidade || profissional&.endereco_cidade || padrao_nulo
  end

  def reagendado?
    !data_reagendamento.nil?
  end

  def tempo_atendimento_segundos
    horario_fim_verdadeiro - horario_inicio_verdadeiro
  end

  def tempo_atendimento_minutos
    tempo_atendimento_segundos / 60
  end

  def tempo_atendimento_horas
    tempo_atendimento_minutos / 60
  end

  # como evento de calendário
  def evento_ics
    "BEGIN:VEVENT" \
      "\n" \
      "SUMMARY:#{tipo.downcase.capitalize} - #{paciente.nome_completo}" \
      "\n" \
      "DTSTAMP:#{Time.current.strftime("%Y%m%dT%H%M%SZ")}" \
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
