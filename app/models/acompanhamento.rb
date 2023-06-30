class Acompanhamento < ApplicationRecord
  belongs_to :profissional
  belongs_to :pessoa
  belongs_to :pessoa_responsavel, class_name: "Pessoa", foreign_key: "pessoa_responsavel_id", optional: true
  belongs_to :acompanhamento_finalizacao_motivo, foreign_key: :finalizacao_motivo_id, optional: true
  belongs_to :acompanhamento_tipo
  belongs_to :atendimento_plataforma, foreign_key: :plataforma_id, optional: true

  has_many :atendimento
  has_many :atendimento_valor, through: :atendimento
  has_many :instrumento_relatos, through: :atendimento
  has_many :instrumentos_aplicados, through: :instrumento_relatos, source: :instrumento
  has_many :recebimento

  has_many :laudos

  def render_info_para_profissional
    p = pessoa
    r = pessoa_responsavel
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{p.nome_abreviado} #{p.render_sexo_sigla} #{if r then '(respondido por ' + r.nome_abreviado + ')' end} com início em #{data_inicio.strftime("%d/%m/%Y")} (#{atendimento.count} #{atendimento.count == 1 ? 'sessão' : 'sessões'})"
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

  def self.em_andamento
    where(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def self.finalizado
    where.not(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end
end
