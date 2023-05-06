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

ActiveRecord::Schema.define(version: 2023_05_06_224428) do

  create_table "civil_estados", force: :cascade do |t|
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crp_regiaos", force: :cascade do |t|
    t.integer "uf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uf_id"], name: "index_crp_regiaos_on_uf_id"
  end

  create_table "instrucao_graus", force: :cascade do |t|
    t.string "grau"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "municipios", force: :cascade do |t|
    t.string "nome"
    t.integer "uf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uf_id"], name: "index_municipios_on_uf_id"
  end

  create_table "parentescos", force: :cascade do |t|
    t.string "parentesco"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profissional_funcoes", force: :cascade do |t|
    t.string "funcao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profissionals", force: :cascade do |t|
    t.string "nome"
    t.string "sobrenome"
    t.boolean "feminino"
    t.string "cpf"
    t.integer "civil_estado_id"
    t.integer "instrucao_grau_id"
    t.date "data_nascimento"
    t.integer "funcao_id"
    t.integer "municipio_id"
    t.string "endereco_cep"
    t.string "endereco_logradouro"
    t.integer "endereco_numero"
    t.string "endereco_complemento"
    t.string "fone_cod_pais"
    t.string "fone_cod_area"
    t.string "fone_num"
    t.string "email", default: "", null: false
    t.text "bio"
    t.integer "salario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["civil_estado_id"], name: "index_profissionals_on_civil_estado_id"
    t.index ["email"], name: "index_profissionals_on_email", unique: true
    t.index ["funcao_id"], name: "index_profissionals_on_funcao_id"
    t.index ["instrucao_grau_id"], name: "index_profissionals_on_instrucao_grau_id"
    t.index ["municipio_id"], name: "index_profissionals_on_municipio_id"
    t.index ["reset_password_token"], name: "index_profissionals_on_reset_password_token", unique: true
  end

  create_table "psicologos", force: :cascade do |t|
    t.string "nome"
    t.string "sobrenome"
    t.string "feminino"
    t.string "cpf"
    t.date "data_nascimento"
    t.string "email", default: "", null: false
    t.string "fone_cod_pais"
    t.string "fone_cod_area"
    t.string "fone_num"
    t.integer "civil_estado_id"
    t.integer "crp_regiao_id"
    t.string "crp_valor"
    t.date "data_colacao"
    t.integer "municipio_id"
    t.text "bio"
    t.string "especializacao_01"
    t.string "especializacao_02"
    t.string "chave_pix_01"
    t.string "chave_pix_02"
    t.integer "papel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["civil_estado_id"], name: "index_psicologos_on_civil_estado_id"
    t.index ["cpf", "email"], name: "index_psicologos_on_cpf_and_email", unique: true
    t.index ["crp_regiao_id"], name: "index_psicologos_on_crp_regiao_id"
    t.index ["email"], name: "index_psicologos_on_email", unique: true
    t.index ["municipio_id"], name: "index_psicologos_on_municipio_id"
    t.index ["reset_password_token"], name: "index_psicologos_on_reset_password_token", unique: true
  end

  create_table "responsavel_usuarios", force: :cascade do |t|
    t.integer "usuario_id"
    t.integer "responsavel_id"
    t.integer "parentesco_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parentesco_id"], name: "index_responsavel_usuarios_on_parentesco_id"
  end

  create_table "ufs", force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
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
    t.integer "municipio_id"
    t.string "endereco_cep"
    t.string "endereco_logradouro"
    t.string "endereco_numero"
    t.string "endereco_complemento"
    t.string "profissao"
    t.string "preferencia_contato"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["civil_estado_id"], name: "index_usuarios_on_civil_estado_id"
    t.index ["instrucao_grau_id"], name: "index_usuarios_on_instrucao_grau_id"
    t.index ["municipio_id"], name: "index_usuarios_on_municipio_id"
  end

end
