class Acompanhamento < ApplicationRecord
  validates :pessoa, :profissional, :data_inicio, :num_sessoes_contrato, presence: true

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
  scope :em_andamento, -> { where(data_final: nil, acompanhamento_finalizacao_motivo: nil, suspenso: [nil, false, 0]) }
  scope :finalizados, -> { where.not(data_final: nil, acompanhamento_finalizacao_motivo: nil) }
  scope :do_profissional, -> (profissional) { profissional.nil? ? all : where(profissional: profissional) }
  scope :do_profissional_com_id, -> (id) { id.nil? ? all : where(profissional_id: id) }
  scope :do_tipo, -> (tipo) { tipo.nil? ? all : where(acompanhamento_tipo: tipo) }
  scope :do_tipo_com_id, -> (id) { id.nil? ? all : where(acompanhamento_tipo_id: id) }
  scope :valor_aproximado_mensal, -> { sum("num_sessoes * valor_sessao") }
  scope :valor_aproximado_semanal, -> { sum(:valor_sessao) }
  scope :do_periodo, -> (de: Acompanhamento.minimum(:data_inicio), ate: Acompanhamento.maximum(:data_final)) { where(data_inicio: de.., data_final: ..ate) }
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

  def render_info_para_profissional
    p = pessoa
    r = pessoa_responsavel
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{p.nome_abreviado} #{p.render_sexo_sigla} #{if r then '(respondido por ' + r.nome_abreviado + ')' end} com início em #{data_inicio.strftime("%d/%m/%Y")} (#{atendimentos.count} #{atendimentos.count == 1 ? 'sessão' : 'sessões'})"
  end

  def render_info_para_profissional_alt
    p = pessoa
    r = pessoa_responsavel
    return "#{p.nome_completo} #{p.render_sexo_sigla} #{if r then '[respondido por ' + r.nome_abreviado + ']' end} - #{tipo.upcase} de #{data_inicio.strftime("%d/%m/%Y")}#{data_final && acompanhamento_finalizacao_motivo ? " a #{data_final.strftime("%d/%m/%Y")}" : ""} <#{profissional.descricao_completa}>"
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

  def instrumentos_aplicados_ate(data = Date.today)
    instrumentos_aplicados.where("atendimentos.data" => [..data])
  end

  def numero_de_sessoes(inicio: "1900-01-01".to_date, final: Date.today)
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

  def infantojuvenil?
    menor_de_idade
  end

  def faixa_etaria
    infantojuvenil? ? "Infantojuvenil" : "Adulto"
  end

  def para_csv formato_data: "%Y-%m-%d"
    "\"#{pessoa.nome_completo}\"," \
      "\"#{pessoa.render_sexo}\"," \
      "\"#{pessoa.render_idade}\"," \
      "\"#{pessoa.render_fone_link}\"," \
      "\"#{pessoa.email}\"," \
      "\"#{faixa_etaria.upcase}\"," \
      "\"#{responsavel_legal&.nome_completo}\"," \
      "\"#{responsavel_legal&.render_fone_link}\"," \
      "\"#{responsavel_legal&.email}\"," \
      "\"#{pessoa.grau_parentesco(responsavel_legal)&.parentesco&.upcase}\"," \
      "\"#{tipo.upcase}\"," \
      "\"#{data_inicio.strftime(formato_data)}\"," \
      "\"#{ultimo_atendimento.data.strftime(formato_data)}\"," \
      "\"#{acompanhamento_finalizacao_motivo&.motivo}\"," \
      "\"#{profissional.descricao_completa}\"," \
      "\"#{atendimentos.count}\"," \
      "\"#{valor_sessao / 100.0}\"," \
      "\"#{num_sessoes}\"," \
      "\"#{suspenso.nil? || suspenso == 0 ? 'NÃO' : 'SIM'}\"," \
      ""
  end

  def self.para_csv collection=all, formato_data: "%Y-%m-%d"
    header = "PACIENTE,SEXO DO PACIENTE,IDADE DO PACIENTE,TELEFONE DO PACIENTE,EMAIL DO PACIENTE," \
      "FAIXA ETÁRIA," \
      "RESPONSÁVEL LEGAL,TELEFONE RESPONSÁVEL LEGAL, EMAIL RESPONSÁVEL LEGAL," \
      "PARENTESCO DO RESPONSÁVEL," \
      "TIPO," \
      "DATA DE INÍCIO," \
      "DATA FINAL," \
      "MOTIVO DA FINALIZAÇÃO," \
      "PROFISSIONAL," \
      "NÚMERO DE ATENDIMENTOS," \
      "VALOR DA SESSÃO," \
      "SESSÕES MENSAIS (4 SEMANAS = 1 MÊS)," \
      "SUSPENSO," \
      "\n"
    content = collection.each.map { |a| a.para_csv(formato_data: formato_data) }.join("\n")
    header + content
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
