# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_05_17_212910) do

  create_table "civil_estados", force: :cascade do |t|
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "continentes", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crefito_regioes", force: :cascade do |t|
    t.integer "uf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uf_id"], name: "index_crefito_regioes_on_uf_id"
  end

  create_table "crefono_regioes", force: :cascade do |t|
    t.integer "uf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uf_id"], name: "index_crefono_regioes_on_uf_id"
  end

  create_table "crn_regioes", force: :cascade do |t|
    t.integer "uf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uf_id"], name: "index_crn_regioes_on_uf_id"
  end

  create_table "crp_regioes", force: :cascade do |t|
    t.integer "uf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uf_id"], name: "index_crp_regioes_on_uf_id"
  end

  create_table "especializacoes", force: :cascade do |t|
    t.string "especializacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instrucao_graus", force: :cascade do |t|
    t.string "grau"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paises", force: :cascade do |t|
    t.string "nome"
    t.string "nome_ingles"
    t.string "nome_oficial"
    t.string "sigla_2"
    t.string "sigla_3"
    t.integer "iso_3166_numerico"
    t.integer "continente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["continente_id"], name: "index_paises_on_continente_id"
  end

  create_table "pessoas", force: :cascade do |t|
    t.string "nome"
    t.string "sobrenome"
    t.string "cpf"
    t.string "fone_cod_pais"
    t.string "fone_cod_area"
    t.string "fone_num"
    t.boolean "feminino"
    t.integer "civil_estado_id"
    t.integer "instrucao_grau_id"
    t.date "data_nascimento"
    t.string "email"
    t.integer "pais_id"
    t.string "estado"
    t.string "cidade"
    t.integer "endereco_cep"
    t.string "endereco_logradouro"
    t.integer "endereco_numero"
    t.string "endereco_complemento"
    t.string "preferencia_contato"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["civil_estado_id"], name: "index_pessoas_on_civil_estado_id"
    t.index ["instrucao_grau_id"], name: "index_pessoas_on_instrucao_grau_id"
    t.index ["pais_id"], name: "index_pessoas_on_pais_id"
  end

  create_table "profissionais", force: :cascade do |t|
    t.integer "pessoa_id"
    t.text "bio"
    t.string "chave_pix_01"
    t.string "chave_pix_02"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pessoa_id"], name: "index_profissionais_on_pessoa_id"
  end

  create_table "profissional_especializacao_juncoes", id: false, force: :cascade do |t|
    t.integer "profissional_id"
    t.integer "especializacao_id"
    t.index ["profissional_id", "especializacao_id"], name: "idx_profissional_especializacao"
  end

  create_table "profissional_funcoes", force: :cascade do |t|
    t.string "funcao"
    t.string "orgao_responsavel"
    t.string "documento_tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profissional_nota", force: :cascade do |t|
    t.integer "profissional_id"
    t.date "data"
    t.time "hora"
    t.string "titulo"
    t.text "nota"
    t.date "data_lembrar"
    t.time "hora_lembrar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profissional_id"], name: "index_profissional_nota_on_profissional_id"
  end

  create_table "profissional_notas", force: :cascade do |t|
    t.integer "profissional_id"
    t.text "nota"
    t.date "data"
    t.time "hora"
    t.date "data_lembrar"
    t.time "hora_lembrar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profissional_id"], name: "index_profissional_notas_on_profissional_id"
  end

  create_table "ufs", force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.integer "pessoa_id"
    t.string "profissao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pessoa_id"], name: "index_usuarios_on_pessoa_id"
  end

end
