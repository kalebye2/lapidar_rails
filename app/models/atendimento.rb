class Atendimento < ApplicationRecord
  belongs_to :acompanhamento
  has_one :atendimento_local
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id

  has_one :relato, foreign_key: :id, primary_key: :id

  accepts_nested_attributes_for :atendimento_valor

  # pessoas envolvidas
  def usuario
    acompanhamento.usuario
  end

  def profissional
    acompanhamento.profissional
  end

  def responsavel
    acompanhamento.usuario_responsavel
  end


  def usuario_presente
    return presenca.to_s == "1"
  end

  def usuario_presente_desc
    usuario_presente ? "Presente" : "Ausente"
  end

  def modalidade
    atendimento_modalidade.modalidade
  end

  def tipo
    atendimento_tipo.tipo.upcase
  end

  def informacoes_com_usuario
    "#{acompanhamento.usuario.nome_completo} - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def informacoes_sem_usuario
   "#{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}" 
  end

  def informacoes_relato
    p = acompanhamento.usuario.pessoa
    "#{p.nome_relato}
    - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def horario_passado
    data < Date.today || (data == Date.today && horario.hour < Time.now.hour )
  end

end
