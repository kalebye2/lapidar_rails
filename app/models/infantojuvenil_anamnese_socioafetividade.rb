class InfantojuvenilAnamneseSocioafetividade < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :amizade_facil
  attribute :prefere_brincar_com_amigos
  attribute :prefere_brincar_com_criancas_menores
  attribute :tendencia_dirigir_outros
  attribute :rir_chorar_facilmente
  attribute :expressa_desejos
  attribute :tendencia_isolamento_inatividade
  attribute :repeticao_gestos_gritos_palavras
  attribute :carinhoso

  self.primary_key = :infantojuvenil_anamnese_id

  def dados
    {
      a_criança_faz_amizade_com_facilidade?: amizade_facil.nil? ? "" : amizade_facil > 0 ? "Sim" : "Não",
      a_criança_prefere_brincar_com_amigos?: prefere_brincar_com_amigos.nil? ? "" : prefere_brincar_com_amigos > 0 ? "Sim" : "Não",
      a_criança_prefere_brincar_com_crianças_menores?: prefere_brincar_com_criancas_menores.nil? ? "" : prefere_brincar_com_criancas_menores > 0 ? "Sim" : "Não",
      a_criança_gosta_de_visitas?: gosta_visitas.nil? ? "" : gosta_visitas > 0 ? "Sim" : "Não",
      quais_as_atividades_preferidas_da_criança?: atividades_preferidas,
      a_criança_tende_a_dirigir_os_outros?: tendencia_dirigir_outros.nil? ? "" : tendencia_dirigir_outros > 0 ? "Sim" : "Não",
      quais_os_tiques_da_criança?: tiques,
      como_é_o_humor_da_criança_no_geral?: humor,
      a_criança_ri_ou_chora_com_facilidade?: rir_chorar_facilmente.nil? ? "" : rir_chorar_facilmente > 0 ? "Sim" : "Não",
      a_criança_expressa_o_que_deseja?: expressa_desejos.nil? ? "" : expressa_desejos > 0 ? "Sim" : "Não",
      a_criança_tende_ao_isolamento_ou_inatividade?: tendencia_isolamento_inatividade.nil? ? "" : tendencia_isolamento_inatividade > 0 ? "Sim" : "Não",
      "a criança repete gestos, gritos ou palavras?" => repeticao_gestos_gritos_palavras.nil? ? "" : repeticao_gestos_gritos_palavras > 0 ? "Sim" : "Não",
      a_criança_é_carinhosa?: carinhoso.nil? ? "" : carinhoso > 0 ? "Sim" : "Não",
      comportamentos_adequados_da_criança: comportamentos_adequados,
      comportamentos_inadequados_da_criança: comportamentos_inadequados,
      outras_considerações: outras_consideracoes,
    }
  end
end
