class InfantojuvenilAnamneseSexualidade < ApplicationRecord
  include ApplicationHelper

  attribute :masturba
  belongs_to :infantojuvenil_anamnese

  self.primary_key = :infantojuvenil_anamnese_id

  def masturba?
    masturba.nil? ? nil : masturba > 0
  end

  def dados
    {
      "a criança demonstra curiosidade sexual?" => sim_ou_nao(curiosidade_sexual),
      "a criança se masturba?" => sim_ou_nao(masturba),
      "quais as atitudes dos pais frente às manifestações de sexualidade da criança?" => atitude_pais,
      "como é a educação sexual da criança?" => educacao_sexual,
      "outras considerações" => outras_consideracoes,
    }
  end
end
