class AtendimentoTipo < ApplicationRecord
  has_many :atendimentos, inverse_of: :atendimento_tipo
  belongs_to :profissional_funcao, optional: true

  scope :da_funcao, -> (profissional_funcao = ProfissionalFuncao.first) { where profissional_funcao: [profissional_funcao, nil]}
end
