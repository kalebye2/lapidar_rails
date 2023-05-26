class Recebimento < ApplicationRecord
  belongs_to :usuario_beneficiario, class_name: "Usuario", foreign_key: :usuario_beneficiario_id
  belongs_to :usuario_pagante, class_name: "Usuario", foreign_key: :usuario_pagante_id
  belongs_to :profissional

  belongs_to :recebimento_modalidade, foreign_key: :modalidade_id
  belongs_to :acompanhamento_tipo
end
