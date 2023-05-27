class Atendimento < ApplicationRecord
  belongs_to :acompanhamento
  has_one :atendimento_local
  belongs_to :atendimento_tipo
  belongs_to :atendimento_modalidade, foreign_key: :modalidade_id

  has_one :atendimento_valor, foreign_key: :atendimento_id, primary_key: :id

  has_one :relato, foreign_key: :id, primary_key: :id

  def usuario_presente
    return presenca.to_s == "1"
  end

  def modalidade
    atendimento_modalidade.modalidade
  end

  def tipo
    atendimento_tipo.tipo
  end

end
