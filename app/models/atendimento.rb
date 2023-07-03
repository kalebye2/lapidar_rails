class Atendimento < ApplicationRecord
  belongs_to :acompanhamento, inverse_of: :atendimentos
  belongs_to :atendimento_local, inverse_of: :atendimentos, optional: true
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id, inverse_of: :atendimentos

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id, inverse_of: :atendimento
  has_one :instrumento_relato
  has_one :infantojuvenil_anamnese

  has_one :relato, foreign_key: :id, primary_key: :id, inverse_of: :atendimento

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
    data < Date.today || (data == Date.today && horario.hour < Time.now.hour)
  end

  def em_andamento
    data == Date.today && horario.hour == Time.now.hour
  end


  def no_futuro
    data > Date.today || (data == Date.today && horario.hour > Time.now.hour)
  end

  def status
    pessoa_presente ? "Realizado" : horario_passado ? "Não realizado" : em_andamento ? "Em andamento" : em_breve ? "Em breve" : "A ocorrer"
  end

  def em_breve
    data == Date.today && horario.hour == Time.now.hour + 1
  end

  def em_breve_ou_em_andamento
    em_breve || em_andamento
  end

  def local
    atendimento_local.nil? ? "Não definido" : atendimento_local.descricao
  end


  def self.realizados
    where(presenca: :true)
  end

  def self.futuros
    where(data: [Date.today + 1.day..]).or(self.where(data: Date.today, horario: [Time.now.beginning_of_hour - 3.hour..]))
  end

  def self.nao_realizados
    where(presenca: false)
  end

  def self.do_mes_atual
    where(data: Date.today.all_month)
  end

  def self.deste_mes
    self.do_mes_atual
  end

  def self.do_mes_passado
    where(data: (Date.today - 1.month).all_month)
  end

  def self.do_ano_atual
    where(data: Date.today.all_year)
  end

  def self.deste_ano
    self.do_ano_atual
  end

  def self.do_ano_passado
    where(data: (Date.today - 1.year).all_year)
  end

  def self.reagendados
    where(reagendado: true)
  end
end
