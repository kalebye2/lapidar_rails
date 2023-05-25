class Usuario < ApplicationRecord
  belongs_to :pessoa

  has_many :acompanhamento


  def nome_completo
    pessoa.nome + ' ' + pessoa.sobrenome
  end
end
