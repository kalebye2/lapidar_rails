class CreateGrupoAtendimentos < ActiveRecord::Migration[7.0]
  def change
    create_table :grupo_atendimentos do |t|
      t.references :grupo, null: false, foreign_key: true
      t.date :data
      t.time :horario
      t.time :horario_fim
      t.references :modalidade, null: false, foreign_key: true
      t.references :atendimento_local, null: false, foreign_key: true
      t.text :anotacoes
      t.text :avancos
      t.text :limitacoes
    end
  end
end
