class CreateCrpRegioes < ActiveRecord::Migration[5.2]
  def change
    create_table :crp_regioes do |t|
      t.references :uf, foreign_key: true

      t.timestamps
    end
  end
end
