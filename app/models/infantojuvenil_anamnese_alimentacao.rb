class InfantojuvenilAnamneseAlimentacao < ApplicationRecord
  include ApplicationHelper
  belongs_to :infantojuvenil_anamnese
  attribute :succao_boa
  attribute :usou_mamadeira
  attribute :rejeicao
  attribute :precisa_ajuda
  self.primary_key = :infantojuvenil_anamnese_id

  def dados
    {
      com_quantos_meses_a_criança_recebeu_alimento_sólido?: solida_meses,
      a_criança_teve_boa_sucção?: sim_ou_nao(succao_boa),
      a_criança_teve_boa_deglutição?: sim_ou_nao(degluticao_boa),
      a_criança_usou_mamadeira?: usou_mamadeira.nil? ? "" : usou_mamadeira > 0 ? "Sim" : "Não",
      com_quantos_meses_a_criança_foi_introduzida_à_comida_de_sal?: deixar_no_plural(comida_sal_introducao_meses, "mês", "meses"),
      com_quantos_meses_ocorreu_o_desmame?: deixar_no_plural(desmame_meses, "mês", "meses"),
      a_criança_rejeitou_alimentos?: sim_ou_nao(rejeicao),
      com_quantos_meses_a_criança_começou_a_comer_sozinha?: deixar_no_plural(comer_sozinho_inicio_meses, "mês", "meses"),
      como_foi_o_início_da_alimentação_da_criança_quando_ela_começou_a_comer_sozinha?: comer_sozinho_inicio_alimento,
      quais_os_comportamentos_da_criança_à_mesa?: comportamento_mesa,
      a_criança_precisa_de_ajuda_para_se_alimentar?: precisa_ajuda.nil? ? "" : precisa_ajuda > 0 ? "Sim" : "Não",
      como_é_a_alimentação_atual_da_criança?: alimentacao_atual,
      outras_considerações: outras_consideracoes,
    }
  end
end
