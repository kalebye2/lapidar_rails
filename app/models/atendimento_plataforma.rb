class AtendimentoPlataforma < ApplicationRecord
  has_many :acompanhamentos, foreign_key: :plataforma_id
  has_many :atendimentos, through: :acompanhamentos
  has_many :pessoas, through: :acompanhamentos
end
