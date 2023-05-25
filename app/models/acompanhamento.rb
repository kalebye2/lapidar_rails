class Acompanhamento < ApplicationRecord
  belongs_to :profissional
  belongs_to :usuario
  belongs_to :usuario_responsavel, class_name: "Usuario", foreign_key: "usuario_responsavel_id", optional: true
  belongs_to :acompanhamento_finalizacao_motivo, foreign_key: :finalizacao_motivo_id
  belongs_to :acompanhamento_tipo
  belongs_to :atendimento_plataforma, foreign_key: :plataforma_id

  has_many :atendimento

  def render_info_para_profissional
    p = usuario.pessoa
    r = usuario_responsavel
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{p.nome} #{p.sobrenome} #{p.render_sexo_sigla} #{if r then '(respondido por ' + r.pessoa.nome + ' ' + r.pessoa.sobrenome + ')' end} (#{atendimento.count} #{atendimento.count == 1 ? 'sessão' : 'sessões'})"
  end

  def render_info_para_usuario
    p = profissional.pessoa
    pro = profissional
    return "#{acompanhamento_tipo.tipo.to_s.upcase} - #{p.nome} #{p.sobrenome} #{pro.render_documento} iniciado em #{ data_inicio.strftime('%d/%m/%Y') }"
  end

end
