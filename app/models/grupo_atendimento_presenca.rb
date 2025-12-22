class GrupoAtendimentoPresenca < ApplicationRecord
  belongs_to :grupo_atendimento
  belongs_to :pessoa
end
