class AcompanhamentoTipo < ApplicationRecord
  has_many :acompanhamento
  belongs_to :profissional_funcao, optional: true

  def default_display
    funcao.upcase
  end
end
