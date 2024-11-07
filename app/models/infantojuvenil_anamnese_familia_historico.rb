class InfantojuvenilAnamneseFamiliaHistorico < ApplicationRecord
  include ApplicationHelper

  belongs_to :infantojuvenil_anamnese
  
  attribute :ambiente_familiar_usuario_consciente_situacao_economica

  self.primary_key = :infantojuvenil_anamnese_id

  def dados
    {
      "quais os antecedentes de transtorno mental na família?" => antecedentes_doenca_mental,
      "há algum antecedente de dependência química na família?" => antecedentes_dependencia_quimica,
      "como descrevem as condições econômicas do ambiente familiar?" => ambiente_familiar_condicoes_economicas,
      "a criança é consciente da situação econômica da família?" => sim_ou_nao(ambiente_familiar_pessoa_consciente_situacao_economica),
      "quais as atitudes da criança relacionadas à situação econômica da família?" => ambiente_familiar_atitude_pessoa_situacao_economica,
      "quem reside com a criança?" => ambiente_familiar_residentes_casa,
      "como é o relacionamento entre os pais da criança?" => ambiente_familiar_relacionamento_pais,
      "como é o relacionamento dos pais com a criança?" => ambiente_familiar_pais_filhos,
      "outras considerações" => outras_consideracoes,
    }
  end
end
