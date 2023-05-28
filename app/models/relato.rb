class Relato < ApplicationRecord
  belongs_to :atendimento, foreign_key: :id, primary_key: :id

  accepts_nested_attributes_for :atendimento
end
