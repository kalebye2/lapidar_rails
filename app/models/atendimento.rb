class Atendimento < ApplicationRecord
  belongs_to :acompanhamento
  has_one :atendimento_local
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id

  has_one :relato, foreign_key: :id, primary_key: :id

  accepts_nested_attributes_for :atendimento_valor

  # pessoas envolvidas
  def pessoa
    acompanhamento.pessoa
  end

  def profissional
    acompanhamento.profissional
  end

  def responsavel
    acompanhamento.pessoa_responsavel
  end

  def acompanhamento_tipo
    acompanhamento.acompanhamento_tipo.tipo
  end


  # the resto
  def pessoa_presente
    return presenca.to_s == "1"
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

  def informacoes_com_pessoa
    "#{acompanhamento.pessoa.nome_completo} - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def informacoes_sem_pessoa
   "#{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}" 
  end

  def informacoes_relato
    p = acompanhamento.pessoa
    "#{p.nome_relato}
    - #{data.strftime('%d/%m/%Y')} às #{horario.strftime('%Hh%M')}"
  end

  def horario_passado
    data < Date.today || (data == Date.today && horario.hour < Time.now.hour )
  end

end
