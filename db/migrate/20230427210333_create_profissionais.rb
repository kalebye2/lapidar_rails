class CreateProfissionais < ActiveRecord::Migration[5.2]
  def change
    create_table :profissionals do |t|
      t.string :nome
      t.string :sobrenome
      t.boolean :feminino
      t.string :cpf
      t.references :civil_estado, foreign_key: true
      t.references :instrucao_grau, foreign_key: true
      t.date :data_nascimento
      t.references :funcao, foreign_key: true
      t.references :municipio, foreign_key: true
      t.string :endereco_cep
      t.string :endereco_logradouro
      t.integer :endereco_numero
      t.string :endereco_complemento
      t.string :fone_cod_pais
      t.string :fone_cod_area
      t.string :fone_num
      t.string :email, null: false, default: ""
      t.text :bio
      t.integer :salario

      t.timestamps
    end
  end
end
