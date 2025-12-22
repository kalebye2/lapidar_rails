class CreateGrupoAtendimentoPresencas < ActiveRecord::Migration[7.0]
  def change
    create_table :grupo_atendimento_presencas do |t|
      t.references :grupo_atendimento, null: false, foreign_key: true
      t.references :pessoa, null: false, foreign_key: true
    end
  end
end
