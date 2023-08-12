class InfantojuvenilAnamneseSono < ApplicationRecord
  attribute :dorme_bem, ActiveRecord::Type::Integer.new
  attribute :pula, ActiveRecord::Type::Integer.new
  attribute :baba, ActiveRecord::Type::Integer.new
  attribute :range_dentes, ActiveRecord::Type::Integer.new
  attribute :fala_grita, ActiveRecord::Type::Integer.new
  attribute :sudorese, ActiveRecord::Type::Integer.new
  attribute :movimento_demasiado, ActiveRecord::Type::Integer.new
  attribute :movimento_sem_lembrar_dia_seguinte, ActiveRecord::Type::Integer.new
  attribute :acorda_varias_vezes, ActiveRecord::Type::Integer.new
  attribute :volta_dormir_facilmente, ActiveRecord::Type::Integer.new
  attribute :dorme_quarto_separado_pais, ActiveRecord::Type::Integer.new
  attribute :cama_individual, ActiveRecord::Type::Integer.new
  attribute :vai_cama_pais, ActiveRecord::Type::Integer.new
end
