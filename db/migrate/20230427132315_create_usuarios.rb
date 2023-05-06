class CreateUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :sobrenome
      t.string :cpf
      t.string :fone_cod_pais
      t.string :fone_cod_area
      t.string :fone_num
      t.boolean :feminino
      t.references :civil_estado, foreign_key: true
      t.references :instrucao_grau, foreign_key: true
      t.date :data_nascimento
      t.string :email
      t.references :municipio, foreign_key: true
      t.string :endereco_cep
      t.string :endereco_logradouro
      t.string :endereco_numero
      t.string :endereco_complemento
      t.string :profissao
      t.string :preferencia_contato

      t.timestamps
    end
  end
end
