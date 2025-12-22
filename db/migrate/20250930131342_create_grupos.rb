class CreateGrupos < ActiveRecord::Migration[7.0]
  def change
    create_table :grupos do |t|
      t.string :nome
      t.references :profissional, foreign_key: true
      t.date :data_criacao
    end
  end
end
