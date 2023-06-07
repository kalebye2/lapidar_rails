class Recebimento < ApplicationRecord
  belongs_to :acompanhamento

  has_one :pessoa, through: :acompanhamento
  belongs_to :pessoa_pagante, class_name: "Pessoa", foreign_key: :pessoa_pagante_id, optional: true
  has_one :profissional, through: :acompanhamento
  #belongs_to :profissional

  belongs_to :recebimento_modalidade, foreign_key: :modalidade_id 

  def pagante
    pessoa_pagante || pessoa
  end

  def beneficiario
    pessoa
  end

  def modalidade
    recebimento_modalidade.modalidade
  end

  def para_linha_csv
    "#{pagante.nome_completo},#{pagante.cpf},#{beneficiario.nome_completo},#{beneficiario.cpf},#{data},#{modalidade},#{valor},#{acompanhamento.acompanhamento_tipo.tipo}" + "\n"
  end

end