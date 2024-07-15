class InfantojuvenilAnamneseSono < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :dorme_bem
  attribute :pula
  attribute :baba
  attribute :range_dentes
  attribute :fala_grita
  attribute :sudorese
  attribute :movimento_demasiado
  attribute :movimento_sem_lembrar_dia_seguinte
  attribute :acorda_varias_vezes
  attribute :volta_dormir_facilmente
  attribute :dorme_quarto_separado_pais
  attribute :cama_individual
  attribute :vai_cama_pais

  self.primary_key = :infantojuvenil_anamnese_id

  def dados
    {
      a_criança_dorme_bem?: dorme_bem.nil? ? "" : dorme_bem > 0 ? "Sim" : "Não",
      a_criança_pula_durante_o_sono?: pula.nil? ? "" : pula > 0 ? "Sim" : "Não",
      a_criança_baba_durante_o_sono?: baba.nil? ? "" : baba > 0 ? "Sim" : "Não",
      a_criança_range_os_dentes_durante_o_sono?: range_dentes.nil? ? "" : range_dentes > 0 ? "Sim" : "Não",
      a_criança_fala_ou_grita_durante_o_sono?: fala_grita.nil? ? "" : fala_grita > 0 ? "Sim" : "Não",
      a_criança_sua_durante_o_sono?: sudorese.nil? ? "" : sudorese > 0 ? "Sim" : "Não",
      a_criança_tem_movimentos_demasiados_durante_o_sono?: movimento_demasiado.nil? ? "" : movimento_demasiado > 0 ? "Sim" : "Não",
      a_criança_se_movimenta_durante_o_sono_sem_lembrar_no_dia_seguinte?: movimentos_sem_lembrar_dia_seguinte.nil? ? "" : movimentos_sem_lembrar_dia_seguinte > 0 ? "Sim" : "Não",
      a_criança_acorda_várias_vezes?: acorda_varias_vezes.nil? ? "" : acorda_varias_vezes > 0 ? "Sim" : "Não",
      a_criança_volta_a_dormir_com_facilidade?: volta_dormir_facilmente.nil? ? "" : volta_dormir_facilmente > 0 ? "Sim" : "Não",
      a_criança_dorme_em_quarto_separado_dos_pais?: dorme_quarto_separado_pais.nil? ? "" : dorme_quarto_separado_pais > 0 ? "Sim" : "Não",
      a_criança_dorme_em_ambiente_compartilhado_com_quem?: dorme_ambiente_compartilhado_com_quem,
      a_criança_dorme_em_cama_individual?: cama_individual.nil? ? "" : cama_individual > 0 ? "Sim" : "Não",
      até_quantos_meses_a_criança_dormiu_no_quarto_dos_pais?: dormiu_quarto_pais_meses,
      a_criança_vai_pra_cama_dos_pais_durante_a_noite?: vai_cama_pais.nil? ? "" : vai_cama_pais > 0 ? "Sim" : "Não",
      qual_a_atitude_dos_pais_quando_a_criança_vai_para_a_cama_deles?: cama_pais_atitude_pais,
      outras_considerações: outras_consideracoes,
    }
  end
end
