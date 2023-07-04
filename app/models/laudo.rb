class Laudo < ApplicationRecord
  belongs_to :acompanhamento
  has_one :pessoa, through: :acompanhamento
  has_one :profissional, through: :acompanhamento

  def paciente
    pessoa
  end

  def data_inicial
    data_inicio_avaliacao || acompanhamento.data_inicio
  end

  def data_final
    data_final_avaliacao || data_avaliacao
  end

  def num_sessoes
    acompanhamento.num_sessoes(inicio: data_inicial, final: data_final)
  end

  def dias_de_avaliacao
    (data_final - data_inicial).to_i
  end
end
