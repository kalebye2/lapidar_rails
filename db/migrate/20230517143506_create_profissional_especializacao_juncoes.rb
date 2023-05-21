class CreateProfissionalEspecializacaoJuncoes < ActiveRecord::Migration[5.2]
  def change
    create_table :profissional_especializacao_juncoes, :id => false do |t|
      t.integer :profissional_id
      t.integer :especializacao_id
    end

    add_index :profissional_especializacao_juncoes, [:profissional_id, :especializacao_id], name: :idx_profissional_especializacao
  end
end
