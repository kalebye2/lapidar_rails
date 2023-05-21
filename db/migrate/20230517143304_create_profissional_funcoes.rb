class CreateProfissionalFuncoes < ActiveRecord::Migration[5.2]
  def change
    create_table :profissional_funcoes do |t|
      t.string :funcao, unique: true
      t.string :orgao_responsavel
      t.string :documento_tipo, unique: true
      t.string :flexao_feminino, unique: true

      t.timestamps
    end
  end
end
