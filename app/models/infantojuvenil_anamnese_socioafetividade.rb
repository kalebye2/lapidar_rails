class InfantojuvenilAnamneseSocioafetividade < ApplicationRecord
  attribute :amizade_facil, ActiveRecord::Type::Integer.new
  attribute :prefere_brincar_com_amigos, ActiveRecord::Type::Integer.new
  attribute :prefere_brincar_com_criancas_menores, ActiveRecord::Type::Integer.new
  attribute :tendencia_dirigir_outros, ActiveRecord::Type::Integer.new
  attribute :rir_chorar_facilmente, ActiveRecord::Type::Integer.new
  attribute :expressa_desejos, ActiveRecord::Type::Integer.new
  attribute :tendencia_isolamento_inatividade, ActiveRecord::Type::Integer.new
  attribute :repeticao_gestos_gritos_palavras, ActiveRecord::Type::Integer.new
  attribute :carinhoso, ActiveRecord::Type::Integer.new
end
