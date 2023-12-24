class Acompanhamento < ApplicationRecord
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

  # scopes
  default_scope { includes(:pessoa, :pessoa_responsavel, :profissional, :acompanhamento_tipo, :acompanhamento_finalizacao_motivo) }
  scope :em_andamento, -> { where(data_final: nil, acompanhamento_finalizacao_motivo: nil) }
  scope :finalizados, -> { where.not(data_final: nil, acompanhamento_finalizacao_motivo: nil) }
  scope :do_profissional, -> (profissional) { profissional.nil? ? all : where(profissional: profissional) }
  scope :do_profissional_com_id, -> (id) { id.nil? ? all : where(profissional_id: id) }
  scope :do_tipo, -> (tipo) { tipo.nil? ? all : where(acompanhamento_tipo: tipo) }
  scope :do_tipo_com_id, -> (id) { id.nil? ? all : where(acompanhamento_tipo_id: id) }
  scope :valor_aproximado_mensal, -> { sum("sessoes_atuais * valor_atual") }
  scope :valor_aproximado_semanal, -> { sum(:valor_atual) }
  scope :do_periodo, -> (de: Acompanhamento.minimum(:data_inicio), ate: Acompanhamento.maximum(:data_final)) { where(data_inicio: de.., data_final: ..ate) }
  scope :por_paciente_em_ordem_alfabetica, -> { includes(:pessoa).order("pessoas.nome" => :asc, "pessoas.nome_do_meio" => :asc, "pessoas.sobrenome" => :asc) }

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

  def num_sessoes(inicio: "1900-01-01".to_date, final: Date.today)
    atendimentos.where(data: [inicio..final]).count
  end

  def em_andamento?
    data_final.nil? && finalizacao_motivo_id.nil?
  end

  def em_espera?
    !data_final.nil? && finalizacao_motivo_id.nil?
  end

  def finalizado?
    !em_andamento?
  end

  def primeiro_atendimento
    atendimentos.order(data: :asc, horario: :asc).first
  end

  def ultimo_atendimento
    atendimentos.order(data: :desc, horario: :desc).first
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
