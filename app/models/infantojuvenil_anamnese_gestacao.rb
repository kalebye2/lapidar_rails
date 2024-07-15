class InfantojuvenilAnamneseGestacao < ApplicationRecord
  include ApplicationHelper

  belongs_to :infantojuvenil_anamnese
  attribute :desejada
  attribute :mae_diabetes
  attribute :mae_traumatismo
  attribute :mae_convulsoes

  belongs_to :parto_tipo, optional: true
  belongs_to :parto_local, optional: true

  self.primary_key = :infantojuvenil_anamnese_id

  def foi_desejada?
    desejada > 0 ? "Sim" : "Não"
  end

  def local_do_parto
    parto_local.nil? ? "Sem informação" : parto_local.local
  end

  def tipo_de_parto
    parto_tipo.nil? ? "Sem informação" : parto_tipo.tipo
  end

  def dados
    {
      a_gestação_foi_desejada?: desejada.nil? ? "" : desejada > 0 ? "Sim" : "Não",
      idade_da_mãe_durante_gestação: deixar_no_plural(idade_mae, "ano", "anos"),
      idade_do_pai_durante_gestação: deixar_no_plural(idade_pai, "ano", "anos"),
      irmãos_mais_velhos: irmaos_mais_velhos,
      irmãos_mais_novos: irmaos_mais_novos,
      quanto_tempo_depois_da_última_gestação_a_criança_foi_concebida?: render_tempo_meses_resumido(gestacao_anterior_meses),
      abortos_anteriores: abortos_anteriores,
      saúde_da_mae_durante_gestação: mae_saude,
      "data_do_pré-natal" => data_pre_natal&.strftime("%m/%Y"),
      sensações_da_mãe_durante_gravidez: mae_sensacoes,
      internações_da_mãe_durante_gravidez: mae_internacoes,
      a_mãe_sentiu_enjoos?: mae_enjoos,
      a_mãe_vomitou_durante_a_gravidez?: mae_vomitos,
      a_mãe_teve_diabetes_durante_a_gravidez?: mae_diabetes.nil? ? "" : mae_diabetes > 0 ? "Sim" : "Não",
      a_mãe_sofreu_traumatismo_durante_a_gravidez?: mae_traumatismo.nil? ? "" : mae_traumatismo > 0 ? "Sim" : "Não",
      a_mãe_teve_convulsões_durante_a_gravidez?: mae_convulsoes.nil? ? "" : mae_convulsoes > 0 ? "Sim" : "Não",
      quais_medicamentos_a_mãe_tomou_durante_a_gravidez?: mae_medicamentos,
      local_do_parto: parto_local&.local,
      tipo_de_parto: parto_tipo&.tipo,
      peso_da_criança_ao_nascer: numero_com_medida(nascimento_peso_g, "g"),
      comprimento_da_criança_ao_nascer: numero_com_medida(nascimento_comprimento_cm, "cm"),
      "duração_da_gestação_(semanas)" => numero_com_medida(gestacao_semanas, " semanas"),
      condições_da_criança_ao_nascer: nascimento_crianca_condicoes,
      reação_da_mãe_ao_nascimento_da_criança: nascimento_reacao_mae,
      reação_do_pai_ao_nascimento_da_criança: nascimento_reacao_pai,
      reação_dos_irmãos_ao_nascimento_da_criança: nascimento_reacao_irmaos,
      desenvolvimento_do_parto: desenvolvimento_parto,
      outras_considerações: outras_consideracoes,
    }
  end
end
