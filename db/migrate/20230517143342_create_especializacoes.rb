class CreateEspecializacoes < ActiveRecord::Migration[5.2]
  def change
    create_table :especializacoes do |t|
      t.string :especializacao

      t.timestamps
    end
  end
end
