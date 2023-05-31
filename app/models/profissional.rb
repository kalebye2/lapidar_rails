class Profissional < ApplicationRecord
  belongs_to :pessoa
  belongs_to :profissional_funcao
  has_and_belongs_to_many :especializacao, through: :profissional_especializacao_juncoes

  has_many :acompanhamento

  def documento
    if profissional_funcao.documento_tipo == nil then return "" end

    "#{profissional_funcao.documento_tipo} #{('00' + documento_regiao_id.to_s)[-2..] }/#{documento_valor}"
  end

  def nome_completo
    pessoa.nome + ' ' + pessoa.sobrenome
  end

  def funcao
    profissional_funcao.funcao
  end

  def descricao_completa
    nome_completo + ' - ' + funcao + ' ' + documento
  end

end
