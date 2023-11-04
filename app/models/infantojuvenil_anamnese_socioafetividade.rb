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
end
