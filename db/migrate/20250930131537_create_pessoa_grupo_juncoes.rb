class CreatePessoaGrupoJuncoes < ActiveRecord::Migration[7.0]
  def change
    create_table :pessoa_grupo_juncoes do |t|
      t.references :pessoa, null: false, foreign_key: true
      t.references :grupo, null: false, foreign_key: true
      t.date :data_entrada
      t.date :data_saida
    end
  end
end
