class CreateProfissionalGrupoJuncoes < ActiveRecord::Migration[7.0]
  def change
    create_table :profissional_grupo_juncoes do |t|
      t.references :profissional, null: false, foreign_key: true
      t.references :grupo, null: false, foreign_key: true
      t.date :data_entrada

    end
  end
end
