class PessoaParentescoJuncao < ApplicationRecord
  # self.primary_key = [:pessoa_id, :parente_id]
  belongs_to :pessoa
  belongs_to :parente, class_name: "Pessoa"
  belongs_to :parentesco, optional: true

  default_scope { includes(:pessoa, :parente, :parentesco) }
end
