class PessoaGrupoJuncao < ApplicationRecord
  belongs_to :pessoa
  belongs_to :grupo
end
