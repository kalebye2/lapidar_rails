class Acompanhamento < ApplicationRecord
  belongs_to :profissional
  belongs_to :pessoa
  belongs_to :pessoa_responsavel, class_name: "Pessoa", foreign_key: "pessoa_responsavel_id", optional: true
  belongs_to :acompanhamento_finalizacao_motivo, foreign_key: :finalizacao_motivo_id, optional: true
  belongs_to :acompanhamento_tipo
  belongs_to :atendimento_plataforma, foreign_key: :plataforma_id, optional: true

  has_many :atendimento
  has_many :atendimento_valor, through: :atendimento
  has_many :recebimento

  def render_info_para_profissional
    p = pessoa
    r = pessoa_responsavel
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{p.nome_completo} #{p.render_sexo_sigla} #{if r then '(respondido por ' + r.nome_completo + ')' end} com início em #{data_inicio.strftime("%d/%m/%Y")} (#{atendimento.count} #{atendimento.count == 1 ? 'sessão' : 'sessões'})"
  end

  def render_info_para_pessoa
    p = profissional.pessoa
    pro = profissional
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{p.nome} #{p.sobrenome} #{pro.documento} iniciado em #{ data_inicio.strftime('%d/%m/%Y') }"
  end

  def tipo upper: false, titulo: false, lower: false
    t = acompanhamento_tipo.tipo
    upper ? t.upcase : titulo ? t.titleize : lower ? t.downcase : t
  end

end
