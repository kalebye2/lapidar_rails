class Usuario < ApplicationRecord
  belongs_to :pessoa

  has_many :acompanhamento
  has_many :acompanhamento_responsavel, class_name: "Acompanhamento", foreign_key: :usuario_responsavel_id


  def nome_completo
    pessoa.nome + ' ' + pessoa.sobrenome
  end
end
