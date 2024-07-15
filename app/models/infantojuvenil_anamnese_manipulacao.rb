class InfantojuvenilAnamneseManipulacao < ApplicationRecord
  include ApplicationHelper
  belongs_to :infantojuvenil_anamnese

  attribute :chupeta_usou
  attribute :chupou_dedo
  attribute :roe_unhas
  attribute :arranca_cabelos

  self.primary_key = :infantojuvenil_anamnese_id

  def dados
    {
      "a criança usou chupeta?" => sim_ou_nao(chupeta_usou),
      "até quantos meses a criança usou chupeta?" => chupeta_usou_meses,
      "como foi a retirada da chupeta?" => chupeta_relato_retirada,
      "a criança chupou dedo?" => sim_ou_nao(chupou_dedo),
      "até quantos meses a criança chupou dedo?" => chupou_dedo_meses,
      "como a criança parou de chupar dedo?" => chupou_dedo_relato_retirada,
      "a criança rói unhas?" => sim_ou_nao(roi_unhas),
      "a criança arranca os próprios cabelos?" => sim_ou_nao(arranca_cabelos),
      "outros pontos sobre a manipulação que acha importante" => outros,
      "quais as atitudes dos responsáveis em relação a essas questões de manipulação?" => atitudes_tomadas_responsaveis,
      "outras considerações" => outras_consideracoes,
    }
  end
end
