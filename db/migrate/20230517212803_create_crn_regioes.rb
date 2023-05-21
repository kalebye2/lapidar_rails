class CreateCrnRegioes < ActiveRecord::Migration[5.2]
  def change
    create_table :crn_regioes do |t|
      t.references :uf, foreign_key: true

      t.timestamps
    end
  end
end
