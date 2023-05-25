class CreatePaises < ActiveRecord::Migration[5.2]
  def change
    create_table :paises do |t|
      t.string :nome
      t.string :nome_ingles
      t.string :nome_oficial
      t.string :sigla_2
      t.string :sigla_3
      t.integer :iso_3166_numerico
      t.references :continente, foreign_key: true

      t.timestamps
    end
  end
end
