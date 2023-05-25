class CreateProfissionalNotas < ActiveRecord::Migration[5.2]
  def change
    create_table :profissional_notas do |t|
      t.references :profissional, foreign_key: true
      t.text :nota
      t.date :data
      t.time :hora
      t.date :data_lembrar
      t.time :hora_lembrar

      t.timestamps
    end
  end
end
