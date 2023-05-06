class CreatePsicologos < ActiveRecord::Migration[5.2]
  def change
    create_table :psicologos do |t|
      t.string :nome
      t.string :sobrenome
      t.string :feminino
      t.string :cpf
      t.date :data_nascimento
      t.string :email, null: false, default: ""
      t.string :fone_cod_pais
      t.string :fone_cod_area
      t.string :fone_num
      t.references :civil_estado, foreign_key: true
      t.references :crp_regiao, foreign_key: true
      t.string :crp_valor
      t.date :data_colacao
      t.references :municipio, foreign_key: true
      t.text :bio
      t.string :especializacao_01
      t.string :especializacao_02
      t.string :chave_pix_01
      t.string :chave_pix_02

      t.integer :papel


      t.timestamps
    end

    # index
    add_index :psicologos, [:cpf, :email], unique: true
  end
end
