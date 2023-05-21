class CreateUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :usuarios do |t|
      t.references :pessoa, foreign_key: true, unique: true
      t.string :profissao

      t.timestamps
    end
  end
end
