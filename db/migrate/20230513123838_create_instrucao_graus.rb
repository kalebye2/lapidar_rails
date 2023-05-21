class CreateInstrucaoGraus < ActiveRecord::Migration[5.2]
  def change
    create_table :instrucao_graus do |t|
      t.string :grau

      t.timestamps
    end
  end
end
