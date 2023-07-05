class Profissional < ApplicationRecord
  belongs_to :pessoa
  belongs_to :profissional_funcao
  has_and_belongs_to_many :especializacao, through: :profissional_especializacao_juncoes

  has_many :acompanhamentos
  has_many :pacientes, through: :acompanhamentos, source: :pessoa
  has_many :responsaveis_por_pacientes, through: :acompanhamentos, source: :pessoa_responsavel
  has_many :atendimentos, through: :acompanhamentos
  has_many :recebimentos, through: :acompanhamentos
  has_many :atendimento_valores, through: :atendimentos
  has_many :repasses, class_name: "ProfissionalFinanceiroRepasse"
  has_many :instrumento_relatos, through: :atendimento
  has_many :instrumentos_que_aplicou, through: :instrumento_relatos, source: :instrumento

  has_many :profissional_documento_modelos


  def documento
    if profissional_funcao.documento_tipo == nil then return "" end

    "#{profissional_funcao.documento_tipo} #{('00' + documento_regiao_id.to_s)[-2..] }/#{documento_valor}"
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

  def descricao_completa
    nome_completo + ' - ' + funcao + ' ' + documento
  end

  def feminino
    pessoa.feminino
  end

  def acompanhamentos_em_andamento
    acompanhamentos.where(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def acompanhamentos_finalizado
    acompanhamentos.where.not(data_final: nil, acompanhamento_finalizacao_motivo: nil)
  end

  def atendimentos_futuros
    atendimentos.where("DATEDIFF(data, CURRENT_DATE) > 0 OR (DATEDIFF(data, CURRENT_DATE) = 0 AND HOUR(horario) > HOUR(CURRENT_TIME))").order(data: :asc, horario: :asc)
  end
end
