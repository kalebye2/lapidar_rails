class CreateCivilEstados < ActiveRecord::Migration[5.2]
  def change
    create_table :civil_estados do |t|
      t.string :estado

      t.timestamps
    end
  end
end
