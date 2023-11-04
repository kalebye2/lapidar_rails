class InfantojuvenilAnamneseManipulacao < ApplicationRecord
  belongs_to :infantojuvenil_anamnese

  attribute :chupeta_usou
  attribute :chupou_dedo
  attribute :roe_unhas
  attribute :arranca_cabelos

  self.primary_key = :infantojuvenil_anamnese_id
end
