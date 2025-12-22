class CreateUfs < ActiveRecord::Migration[5.2]
  def change
    create_table :ufs do |t|
      t.string :nome
      t.string :sigla
    end
  end
end
