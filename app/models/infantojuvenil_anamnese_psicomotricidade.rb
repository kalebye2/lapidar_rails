class InfantojuvenilAnamnesePsicomotricidade < ApplicationRecord
  belongs_to :infantojuvenil_anamnese
  attribute :canhoto
  attribute :precisa_ajuda_banheiro
  attribute :toma_banho_sozinho
  attribute :veste_sozinho
  attribute :caia_muito
  attribute :conhecimento_lateralidade

  self.primary_key = :infantojuvenil_anamnese_id

  def canhoto?
    canhoto.nil? ? nil : canhoto > 0
  end

  def precisa_ajuda_banheiro?
    precisa_ajuda_banheiro.nil? ? nil : precisa_ajuda_banheiro > 0
  end

  def toma_banho_sozinho?
    toma_banho_sozinho.nil? ? nil : toma_banho_sozinho > 0
  end

  def veste_sozinho?
    veste_sozinho.nil? ? nil : veste_sozinho > 0
  end

  def caia_muito?
    caia_muito.nil? ? nil : caia_muito > 0
  end

  def conhecimento_lateralidade?
    conhecimento_lateralidade.nil? ? nil : conhecimento_lateralidade > 0
  end

  def dados
    {
      com_quantos_meses_a_criança_sorriu?: sorriu_meses,
      com_quantos_meses_a_criança_se_dirigiu_ativamente_às_pessoas?: dirigir_ativamente_pessoas_meses,
      com_quantos_meses_a_criança_ergueu_a_cabeça?: ergueu_cabeca_meses,
      com_quantos_meses_a_criança_sentou?: sentou_meses,
      com_quantos_meses_a_criança_engatinhou?: engatinhou_meses,
      com_quantos_meses_a_criança_andou?: andou_meses,
      com_quantos_meses_surgiram_os_primeiros_dentes?: denticao_meses,
      canhoto?: canhoto.nil? ? "" : canhoto > 0 ? "Sim" : "Não",
      "com_quantos_meses_a_criança_teve_controle_do_esfíncter_(cocô)_durante_o_dia?" => controle_esfincter_diurno_meses,
      "com_quantos_meses_a_criança_teve_controle_do_esfíncter_(cocô)_durante_a_noite?" => controle_esfincter_noturno_meses,
      "com_quantos_meses_a_criança_teve_controle_vesical_(xixi)__durante_o_dia?" => controle_esfincter_diurno_meses,
      "com_quantos_meses_a_criança_teve_controle_vesical_(xixi)__durante_a_noite?" => controle_esfincter_noturno_meses,
      "como_foi_ensinado_o_controle_do_esfíncter_(cocô)?" => ensino_controle_esfincter,
      "como era a atitude da criança diante da enurese (xixi na cama)?" => atitude_enurese,
      a_criança_precisa_de_ajuda_para_usar_o_banheiro?: precisa_ajuda_banheiro.nil? ? "" : precisa_ajuda_banheiro > 0 ? "Sim" : "Não",
      a_criança_toma_banho_sozinha?: toma_banho_sozinho.nil? ? "" : toma_banho_sozinho > 0 ? "Sim" : "Não",
      a_criança_se_veste_sozinha?: veste_sozinho.nil? ? "" : veste_sozinho > 0 ? "Sim" : "Não",
      a_criança_caía_muito?: caia_muito.nil? ? "" : caia_muito > 0 ? "Sim" : "Não",
      "a criança tem conhecimento de lateralidade (esquerdo e direito)?" => conhecimento_lateralidade.nil? ? "" : conhecimento_lateralidade > 0 ? "Sim" : "Não",
      outras_considerações: outras_consideracoes,
    }
  end
end
