class InfantojuvenilAnamneseSaudeHistorico < ApplicationRecord
  include ApplicationHelper

  belongs_to :infantojuvenil_anamnese

  attribute :acompanhamento_medico
  attribute :acidente_sofrido

  self.primary_key = :infantojuvenil_anamnese_id

  def dados
    {
      "a criança faz acompanhamento médico?" => sim_ou_nao(acompanhamento_medico),
      "a criança sofreu algum acidente?" => sim_ou_nao(acidente_sofrido),
      "a criança possui alguma doença?" => doencas,
      "a criança teve ou tem alguma doença grave? Se sim, como foi a evolução?" => doenca_grave_e_evolucao,
      "a criança faz uso de quais medicamentos?" => medicamentos,
      "como é a visão da criança?" => visao,
      "como é a audição da criança?" => audicao,
      "como descreveria o nível de inteligência da criança?" => inteligencia,
      "qual(is) a(s) consequência(s) do(s) acidente(s) sofrido(s)?" => acidente_consequencias,
      "outras considerações" => outras_consideracoes,
    }
  end
end
