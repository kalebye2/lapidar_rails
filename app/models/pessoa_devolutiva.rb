class PessoaDevolutiva < ApplicationRecord
  belongs_to :pessoa
  belongs_to :profissional
  belongs_to :responsavel, class_name: "Pessoa", foreign_key: :pessoa_responsavel_id
end
