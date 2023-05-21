class CreateProfissionais < ActiveRecord::Migration[5.2]
  def change
    create_table :profissionais do |t|
      t.references :pessoa, foreign_key: true, unique: true
      t.references :profissional_funcao, foreign_key: true
      t.text :bio
      t.string :chave_pix_01
      t.string :chave_pix_02

      t.timestamps
    end
  end
end
