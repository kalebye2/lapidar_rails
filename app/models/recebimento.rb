class Recebimento < ApplicationRecord
  belongs_to :acompanhamento

  has_one :pessoa, through: :acompanhamento
  belongs_to :pessoa_pagante, class_name: "Pessoa", foreign_key: :pessoa_pagante_id, optional: true
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

end
