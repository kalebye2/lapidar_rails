class Acompanhamento < ApplicationRecord

  include Monetizavel

  Monetizavel.de_centavos_pra_real :valor_sessao, :valor_sessao_contrato

  validates :pessoa, :profissional, :data_inicio, :num_sessoes_contrato, presence: true

  before_save do
    mudar = {
      valor_sessao: self.valor_sessao,
      valor_sessao_contrato: self.valor_sessao_contrato,
    }

    mudar = mudar.map { |k,v|
      final_valor = v&.to_s || "0,00"
      if !final_valor.include?(",")
        final_valor += ","
      end
      final_valor.gsub!(".", "")
      index_virgula = final_valor.index(",")
      valor_inteiros = final_valor[..index_virgula - 1]
      valor_decimais = ((final_valor[index_virgula + 1..]) + "00")[..1]
      [k, "#{valor_inteiros}#{valor_decimais}".gsub(",", "").to_i]
    }.to_h
    self.valor_sessao = mudar[:valor_sessao] if self.valor_sessao_changed?
    self.valor_sessao_contrato = mudar[:valor_sessao_contrato] if self.valor_sessao_contrato_changed?
  end

  belongs_to :profissional
  belongs_to :pessoa
  belongs_to :pessoa_responsavel, class_name: "Pessoa", foreign_key: "pessoa_responsavel_id", optional: true
  belongs_to :acompanhamento_finalizacao_motivo, foreign_key: :finalizacao_motivo_id, optional: true
  belongs_to :acompanhamento_tipo
  belongs_to :atendimento_plataforma, foreign_key: :plataforma_id, optional: true

  has_many :atendimentos
  has_many :atendimento_valores, through: :atendimentos
  has_many :instrumento_relatos, through: :atendimentos
  has_many :instrumentos_aplicados, through: :instrumento_relatos, source: :instrumento
  has_many :recebimentos

  has_many :laudos

  has_many :acompanhamento_horarios
  has_many :acompanhamento_reajustes

  # scopes
  default_scope { includes(:pessoa, :pessoa_responsavel, :profissional, :acompanhamento_tipo, :acompanhamento_finalizacao_motivo) }
  scope :em_andamento, -> { where(acompanhamento_finalizacao_motivo: nil, suspenso: [nil, false, 0]) }
  scope :finalizados, -> { where.not(acompanhamento_finalizacao_motivo: nil) }
  scope :do_profissional, -> (profissional) { profissional.nil? ? all : where(profissional: profissional) }
  scope :do_profissional_com_id, -> (id) { id.nil? ? all : where(profissional_id: id) }
  scope :do_tipo, -> (tipo) { tipo.nil? ? all : where(acompanhamento_tipo: tipo) }
  scope :do_tipo_com_id, -> (id) { id.nil? ? all : where(acompanhamento_tipo_id: id) }
  scope :valor_aproximado_mensal, -> { sum("num_sessoes * valor_sessao") }
  scope :valor_aproximado_semanal, -> { sum(:valor_sessao) }
  scope :do_periodo_de_ate, -> (de: Acompanhamento.minimum(:data_inicio), ate: Acompanhamento.maximum(:data_final)) { where(data_inicio: de.., data_final: ..ate) }
  scope :por_paciente_em_ordem_alfabetica, -> { includes(:pessoa).order("pessoas.nome" => :asc, "pessoas.nome_do_meio" => :asc, "pessoas.sobrenome" => :asc) }
  scope :suspensos, -> { where(suspenso: [true, 1..]) }

  scope :contagem_por_profissional, -> (profissionais = Profissional.all) { where(profissional: profissionais).group(:profissional).count }

  scope :contagem_por_status, -> (motivos=AcompanhamentoFinalizacaoMotivo.all) { group(:acompanhamento_finalizacao_motivo).count }
  scope :contagem_por_tipo, -> (tipos=AcompanhamentoTipo.all) { group(:acompanhamento_tipo).count }

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

  accepts_nested_attributes_for :acompanhamento_reajustes

  def default_display
    render_info_para_profissional_alt
  end

  def render_info_para_profissional
    p = pessoa
    r = pessoa_responsavel
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{p.nome_abreviado} #{p.render_sexo_sigla} #{if r then '(respondido por ' + r.nome_abreviado + ')' end} com início em #{data_inicio.strftime("%d/%m/%Y")} (#{atendimentos.count} #{atendimentos.count == 1 ? 'sessão' : 'sessões'})"
  end

  def render_info_para_profissional_alt
    p = pessoa
    r = pessoa_responsavel
    return "#{p.nome_completo} #{p.render_sexo_sigla} #{if r then '[respondido por ' + r.nome_abreviado + ']' end} - #{tipo.upcase} de #{data_inicio.strftime("%d/%m/%Y")}#{data_final && acompanhamento_finalizacao_motivo ? " a #{data_final.strftime("%d/%m/%Y")}" : ""} <#{profissional.descricao_completa}>" if p
  end

  def render_info_para_pessoa
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{profissional.nome_abreviado} #{profissional.documento} iniciado em #{ data_inicio.strftime('%d/%m/%Y') }"
  end

  def render_info_padrao
    p = pessoa
    r = pessoa_responsavel
    return "#{p.nome_abreviado} #{p.render_sexo_sigla} #{if r then 'respondido por ' + r.nome_abreviado + ')' end} - #{profissional.nome_abreviado} (#{tipo.to_s.upcase} com início em #{data_inicio.strftime("%d/%m/%Y")})"
  end

  def paciente
    pessoa
  end

  def responsavel_legal
    pessoa_responsavel
  end

  def tipo upper: false, titulo: false, lower: false
    t = acompanhamento_tipo.tipo
    upper ? t.upcase : titulo ? t.titleize : lower ? t.downcase : t
  end

  def instrumentos_aplicados_ate(data = Date.current)
    instrumentos_aplicados.where("atendimentos.data" => [..data])
  end

  def numero_de_sessoes(inicio: "1900-01-01".to_date, final: Date.current)
    atendimentos.where(data: [inicio..final]).count
  end

  def status
    if suspenso? && acompanhamento_finalizacao_motivo.nil? then return "Suspenso" end
    if em_andamento? then return "Em andamento" end
    "Finalizado"
  end

  def motivo_da_finalizacao
    acompanhamento_finalizacao_motivo&.motivo || ""
  end

  def em_andamento?
    finalizacao_motivo_id.nil? && (suspenso.nil? || suspenso == 0)
  end

  def em_espera?
    !data_final.nil? && finalizacao_motivo_id.nil?
  end

  def finalizado?
    !em_andamento?
  end

  def suspenso?
    !suspenso.nil? && suspenso > 0
  end

  def primeiro_atendimento
    atendimentos.order(data: :asc, horario: :asc).first
  end

  def ultimo_atendimento
    atendimentos.order(data: :desc, horario: :desc).first
  end

  def primeira_data
    data_inicio || primeiro_atendimento&.data
  end

  def ultima_data
    data_final || ultimo_atendimento&.data
  end

  def infantojuvenil?
    menor_de_idade
  end

  def faixa_etaria
    infantojuvenil? ? "Infantojuvenil" : "Adulto"
  end

  # financeiro
  
  def valor_liquido
    atendimento_valores.soma_liquidos
  end

  def valor_bruto
    atendimento_valores.soma_brutos
  end

  def valor_a_cobrar_ate_mes_passado
    atendimento_valores.where(atendimentos: {data: [..(Date.current - 1.month).end_of_month]}).sum("valor - desconto") - recebimentos.sum(:valor)
  end

  def valor_a_cobrar(periodo=..Date.current.end_of_month)
    (atendimento_valores.do_periodo(periodo).sum("valor - desconto") - recebimentos.sum(:valor)).to_i
  end

  def valor_a_ressarcir(periodo=..Date.current.end_of_month)
    valor_final = (atendimento_valores.do_periodo(periodo).sum("valor - desconto") - recebimentos.do_periodo(periodo).sum(:valor)).to_i
    valor_final < 0 ? valor_final * -1 : 0
  end

  def valor_recebido_no_periodo periodo = (Date.today - 1.year).all_year
    recebimentos.do_periodo(periodo).sum(:valor).to_i
  end

  def cidade padrao_nulo=nil
    atendimento_final = atendimentos.realizados.em_ordem.last
    atendimento_final&.atendimento_local&.endereco_cidade ||
      profissional.endereco_cidade || padrao_nulo ||
      Rails.config.application.clinica_endereco[:cidade] || "Brasília"
  end

  def para_csv col_sep: ",", formato_data: "%Y-%m-%d"
    # "\"#{pessoa.nome_completo}\"," \
    #   "\"#{pessoa.render_sexo}\"," \
    #   "\"#{pessoa.render_idade}\"," \
    #   "\"#{pessoa.render_fone_link}\"," \
    #   "\"#{pessoa.email}\"," \
    #   "\"#{faixa_etaria.upcase}\"," \
    #   "\"#{responsavel_legal&.nome_completo}\"," \
    #   "\"#{responsavel_legal&.render_fone_link}\"," \
    #   "\"#{responsavel_legal&.email}\"," \
    #   "\"#{pessoa.grau_parentesco(responsavel_legal)&.parentesco&.upcase}\"," \
    #   "\"#{tipo.upcase}\"," \
    #   "\"#{data_inicio.strftime(formato_data)}\"," \
    #   "\"#{ultimo_atendimento&.data&.strftime(formato_data)}\"," \
    #   "\"#{acompanhamento_finalizacao_motivo&.motivo}\"," \
    #   "\"#{profissional.descricao_completa}\"," \
    #   "\"#{atendimentos.count}\"," \
    #   "\"#{valor_sessao / 100.0}\"," \
    #   "\"#{num_sessoes}\"," \
    #   "\"#{suspenso.nil? || suspenso == 0 ? 'NÃO' : 'SIM'}\"," \
    #   ""

    CSV.generate(col_sep: col_sep) do |csv|
      csv << [
        pessoa.nome_completo,
        pessoa.render_sexo,
        pessoa.render_idade,
        pessoa.idade_anos,
        pessoa.render_fone_link,
        pessoa.email,
        faixa_etaria.upcase,
        responsavel_legal&.nome_completo,
        responsavel_legal&.render_fone_link,
        responsavel_legal&.email,
        pessoa.grau_parentesco(responsavel_legal)&.parentesco&.upcase,
        tipo.upcase,
        data_inicio.strftime(formato_data),
        ultimo_atendimento&.data&.strftime(formato_data),
        acompanhamento_finalizacao_motivo&.motivo,
        profissional.descricao_completa,
        atendimentos.count,
        valor_sessao / 100.0,
        num_sessoes,
        suspenso.nil? || suspenso == 0 ? 'NÃO' : 'SIM',
      ]
    end
  end

  def prontuario_csv formato_data: "%Y-%m-%d", col_sep: ","
    header = [
      "id",
      "data",
      "horario",
      "status",
      "atividade",
      "anotacoes",
      "instrumentos_usados",
    ].map(&:upcase)

    CSV.generate(col_sep: col_sep) do |csv|
      csv << header
      atendimentos.em_ordem.each_with_index do |atendimento, index|
        csv << [
          index + 1,
          atendimento.data_inicio_verdadeira.strftime(formato_data),
          atendimento.horario_inicio_verdadeiro.strftime("%H:%M:%S"),
          atendimento.status&.upcase,
          atendimento.tipo.upcase,
          atendimento.anotacoes,
          atendimento.instrumentos_aplicados.map(&:nome_e_sigla).join(";"),
        ]
      end
    end
  end

  def proxima_data_de_atendimento_a_partir_de_hoje
    tempo_semanas = num_sessoes == 0 ? 4 : num_sessoes
    semanas_pra_passar = 4.0 / tempo_semanas
    horarios_do_acompanhamento = acompanhamento_horarios.order(:semana_dia_id)
    primeiro_dia = Date.current + (semanas_pra_passar - 1).week
    proximos_dias_desta_semana = (primeiro_dia..(primeiro_dia + 1.week)).map { |dia| [dia.wday, dia] }.to_h

    # folgas
    folgas = profissional.folgas.no_periodo((Date.current + semanas_pra_passar.week))
    proxima_semana = nil

    #TODO AQUI

    proximo_dia = nil
    proximo_horario = nil
    proximo_horario_fim = nil

    if folgas.first == nil
      proxima_semana = (Date.current + semanas_pra_passar.week).all_week.map { |d| {d.wday => d} }
      proximo_dia = nil
      proximo_horario = nil
      proximo_horario_fim = nil
      proximos_dias_desta_semana.each do |k,v|
        horarios_do_acompanhamento.each do |horario|
          if k == horario.semana_dia_id && proximo_dia.blank?
            proximo_dia = v
            proximo_horario = horario.horario
            proximo_horario_fim = horario.horario_fim
          end
        end
      end
    else
    end

    au = atendimentos.em_ordem.last

    {
      data: proximo_dia || au.data + 1.week,
      horario: proximo_horario || au.horario,
      horario_fim: proximo_horario_fim || au.horario_fim,
    }
  end

  def tempo_atendimentos_minutos
    atendimentos.map &:tempo_atendimento_minutos
  end

  def tempo_total_atendimentos_minutos
    tempo_atendimentos_minutos.sum
  end

  def tempo_total_atendimentos_horas
    tempo_total_atendimentos_minutos / 60.0
  end

  def self.tempo_total_atendimentos_minutos collection=all
    collection.map(&:tempo_total_atendimentos_minutos).sum
  end

  def self.tempo_total_atendimentos_horas collection=all
    collection.map(&:tempo_total_atendimentos_horas).sum
  end

  def self.para_csv collection=all, formato_data: "%Y-%m-%d", col_sep: ","
    header = [
      "paciente",
      "sexo_do_paciente",
      "idade_do_paciente",
      "idade_em_anos",
      "telefone_do_paciente",
      "email_do_paciente",
      "faixa_etária",
      "responsável_legal",
      "telefone_responsável_legal",
      "email_responsável_legal",
      "parentesco_do_responsável",
      "tipo",
      "data_de_início",
      "data_final",
      "motivo_da_finalização",
      "profissional",
      "número_de_atendimentos",
      "valor_da_sessão",
      "sessões_mensais_(4_semanas_= 1_mês)",
      "suspenso",
      "plataforma",
      "atendimentos_realizados",
      "atendimentos_não_realizados",
      "proporção_de_atendimentos_realizados/não_realizados",
    ]
    # content = collection.each.map { |a| a.para_csv(formato_data: formato_data) }.join("\n")

    CSV.generate(col_sep: col_sep) do |csv|
      csv << header
      collection.each do |a|
        csv << [
          a.pessoa.nome_completo,
          a.pessoa.render_sexo,
          a.pessoa.render_idade,
          a.pessoa.idade_anos,
          a.pessoa.render_fone_link,
          a.pessoa.email,
          a.faixa_etaria.upcase,
          a.responsavel_legal&.nome_completo,
          a.responsavel_legal&.render_fone_link,
          a.responsavel_legal&.email,
          a.pessoa.grau_parentesco(a.responsavel_legal)&.parentesco&.upcase,
          a.tipo.upcase,
          a.data_inicio.strftime(formato_data),
          a.em_andamento? ? nil : a.ultima_data&.strftime(formato_data),
          a.acompanhamento_finalizacao_motivo&.motivo,
          a.profissional.descricao_completa,
          a.atendimentos.count,
          a.valor_sessao / 100.0,
          a.num_sessoes,
          a.suspenso.nil? || a.suspenso == 0 ? 'NÃO' : 'SIM',
          a.atendimento_plataforma&.nome,
          a.atendimentos.realizados.count,
          a.atendimentos.passados.nao_realizados.count,
          (a.atendimentos.realizados.count.to_f / (a.atendimentos.passados.count == 0 ? 1 : a.atendimentos.passados.count).to_f),
        ]
      end
    end
  end

  def self.filter(attributes)
    attributes.select { |k, v| v.present? }.reduce(all) do |scope, (key, value)|
      case key.to_sym
        # tipo id
      when :acompanhamento_tipo_id
        scope.where(key => value)
      end
    end
  end
end
