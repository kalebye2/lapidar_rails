class PessoaDevolutiva < ApplicationRecord
  belongs_to :pessoa
  belongs_to :profissional
end
