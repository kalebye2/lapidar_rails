class Profissional < ApplicationRecord
  belongs_to :pessoa
  belongs_to :profissional_funcao
  has_one :usuario
  has_many :profissional_especializacao_juncoes, foreign_key: :profissional_id
  has_many :especializacoes, through: :profissional_especializacao_juncoes

  has_many :acompanhamentos
  has_many :pacientes, through: :acompanhamentos, source: :pessoa
  has_many :responsaveis_por_pacientes, through: :acompanhamentos, source: :pessoa_responsavel
  has_many :atendimentos, through: :acompanhamentos
  has_many :recebimentos, through: :acompanhamentos
  has_many :laudos, through: :acompanhamentos
  has_many :atendimento_valores, through: :atendimentos
  has_many :repasses, class_name: "ProfissionalFinanceiroRepasse"
  has_many :instrumento_relatos, through: :atendimento
  has_many :instrumentos_que_aplicou, through: :instrumento_relatos, source: :instrumento

  has_many :profissional_documento_modelos

  has_many :profissional_especializacao_juncoes
  has_many :profissional_especializacoes, through: :profissional_especializacao_juncoes

  scope :com_atendimentos_futuros, -> { includes(:atendimentos).where("atendimentos.data" => Date.today.. )}
  scope :ordem_alfabetica, -> { includes(:pessoa).order("pessoas.nome" => :asc, "pessoas.nome_do_meio" => :asc, "pessoas.sobrenome" => :asc) }
  default_scope { includes(:pessoa, :usuario, :profissional_funcao) }


  def clientes
    pacientes
  end

  def documento
    if profissional_funcao.documento_tipo == nil then return "" end

    "#{profissional_funcao.documento_tipo} #{('00' + documento_regiao_id.to_s)[-2..] }/#{documento_valor}"
  end

  def email
    pessoa.email
  end

  def nome_completo
    pessoa.nome_completo
  end

  def nome_abreviado
    pessoa.nome_abreviado
  end

  def nome_abreviado_meio
    pessoa.nome_abreviado_meio
  end

  def nome_sigla
    pessoa.nome_sigla
  end

  def nome_e_sobrenome
    pessoa.nome_e_sobrenome
  end

  def username_padrao
    n = pessoa.nome_e_sobrenome.split.reverse
    "#{n[0].downcase}.#{n[1].downcase}"
  end

  def funcao
    pessoa.feminino? ? (profissional_funcao.flexao_feminino || profissional_funcao.funcao[..-2] +  'a') : profissional_funcao.funcao
  end

  def servico
    profissional_funcao.servico
  end

  def cidade
    pessoa.cidade
  end

  def render_cpf
    pessoa.render_cpf
  end

  def descricao_completa
    nome_completo + ' - ' + funcao + ' ' + documento
  end

  def feminino
    pessoa.feminino
  end

  def render_idade
    pessoa.render_idade
  end

  def acompanhamentos_em_andamento
    acompanhamentos.where(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def acompanhamentos_finalizados
    acompanhamentos.where.not(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def atendimentos_futuros
    #atendimentos.where("DATEDIFF(data, CURRENT_DATE) > 0 OR (DATEDIFF(data, CURRENT_DATE) = 0 AND HOUR(horario) > HOUR(CURRENT_TIME))").order(data: :asc, horario: :asc)
    atendimentos.where(data: Date.today..)
  end

  def financeiro_soma_atendimentos de: Date.today.beginning_of_month, ate: Date.today.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date }).sum(:valor)
  end

  def financeiro_soma_atendimentos_todos
    atendimento_valores.sum(:valor)
  end

  def financeiro_soma_liquida_atendimentos_todos
    atendimento_valores.sum("valor - (valor * taxa_porcentagem_externa / 10000) - (valor * taxa_porcentagem_interna / 10000)")
  end

  def financeiro_soma_taxa_clinica de: Date.today.beginning_of_month, ate: Date.today.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: {data: de.to_date..ate.to_date}).sum("valor * taxa_porcentagem_interna / 10000")
  end

  def financeiro_soma_taxa_clinica_todos
    atendimento_valores.sum("valor * taxa_porcentagem_interna / 10000")
  end

  def financeiro_soma_taxa_externa de: Date.today.beginning_of_month, ate: Date.today.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: {data: de.to_date..ate.to_date}).sum("valor * taxa_porcentagem_externa / 10000")
  end

  def financeiro_soma_taxa_externa_todos
    atendimento_valores.sum("valor * taxa_porcentagem_externa / 10000")
  end

  def financeiro_soma_liquida_atendimentos de: Date.today.beginning_of_month, ate: Date.today.end_of_month
    atendimento_valores.joins(:atendimento).where(atendimento: { data: de.to_date..ate.to_date }).sum("valor - (valor * taxa_porcentagem_externa / 10000) - (valor * taxa_porcentagem_interna / 10000)")
  end

  def financeiro_soma_repasses
    repasses.sum(:valor)
  end

  def financeiro_soma_recebimentos
    recebimentos.sum(:valor)
  end

  def financeiro_clinica_deve
    recebimentos.sum("valor - (valor * taxa_porcentagem_clinica / 10000)") - repasses.sum(:valor)
  end

end
