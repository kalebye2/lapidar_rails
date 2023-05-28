class Atendimento < ApplicationRecord
  belongs_to :acompanhamento
  has_one :atendimento_local
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id

  has_one :relato, foreign_key: :id, primary_key: :id

  def usuario_presente
    return presenca.to_s == "1"
  end

  def modalidade
    atendimento_modalidade.modalidade
  end

  def tipo
    atendimento_tipo.tipo
  end

  def informacoes_com_usuario
    "#{acompanhamento.usuario.nome_completo} - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def informacoes_sem_usuario
   "#{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}" 
  end

  def informacoes_relato
    p = acompanhamento.usuario.pessoa
    "#{p.nome[-2..].upcase}#{p.sobrenome[..2].upcase}#{p.nome[..1].upcase}
    - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

end
