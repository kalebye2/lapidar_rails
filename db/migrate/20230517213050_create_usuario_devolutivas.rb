class CreateUsuarioDevolutivas < ActiveRecord::Migration[5.2]
  def change
    create_table :usuario_devolutivas do |t|
      t.references :usuario, foreign_key: true
      t.integer :usuario_responsavel_id, foreign_key: true, table: :usuarios
      t.references :profissional, foreign_key: true
      t.date :data
      t.text :feedback_responsavel
      t.text :orientacoes_profissional

      t.timestamps
    end
  end
end
