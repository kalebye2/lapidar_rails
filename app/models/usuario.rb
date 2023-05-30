class Usuario < ApplicationRecord
  belongs_to :pessoa

  has_many :acompanhamento
  has_many :acompanhamento_responsavel, class_name: "Acompanhamento", foreign_key: :usuario_responsavel_id

  has_many :usuario_extra_informacao


  def nome_completo
    pessoa.nome + ' ' + pessoa.sobrenome
  end

  def nome_relato
    pessoa.nome_relato
  end
end
