class Recebimento < ApplicationRecord
  belongs_to :pessoa_beneficiario, class_name: "Pessoa", foreign_key: :pessoa_beneficiario_id
  belongs_to :pessoa_pagante, class_name: "Pessoa", foreign_key: :pessoa_pagante_id, optional: true
  belongs_to :profissional

  belongs_to :recebimento_modalidade, foreign_key: :modalidade_id
  belongs_to :acompanhamento_tipo
  

  def pagante
    pessoa_pagante || pessoa_beneficiario
  end

  def modalidade
    recebimento_modalidade.modalidade
  end


end
