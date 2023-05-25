class Relato < ApplicationRecord
  belongs_to :atendimento, foreign_key: :id
end
