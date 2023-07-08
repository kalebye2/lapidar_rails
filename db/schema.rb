# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 0) do
  create_table "acompanhamento_finalizacao_motivos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "motivo", limit: 100
  end

  create_table "acompanhamento_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "acompanhamentos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.integer "profissional_id", null: false
    t.integer "plataforma_id"
    t.string "motivo"
    t.date "data_inicio", null: false
    t.date "data_final"
    t.integer "finalizacao_motivo_id"
    t.integer "valor_contrato"
    t.integer "sessoes_contrato", null: false
    t.integer "valor_atual"
    t.integer "sessoes_atuais"
    t.integer "acompanhamento_tipo_id"
    t.string "menor_de_idade", limit: 1, null: false
    t.integer "pessoa_responsavel_id"
    t.integer "sessoes_previstas"
    t.index ["acompanhamento_tipo_id"], name: "acompanhamento_tipo_id"
    t.index ["finalizacao_motivo_id"], name: "finalizacao_motivo_id"
    t.index ["pessoa_id"], name: "usuario_id"
    t.index ["pessoa_responsavel_id"], name: "usuario_responsavel_id"
    t.index ["plataforma_id"], name: "plataforma_id"
    t.index ["profissional_id"], name: "profissional_id"
  end

  create_table "atendimento_locais", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "atendimento_local_tipo_id", null: false
    t.string "descricao", null: false
    t.integer "pais_id"
    t.string "estado"
    t.string "cidade"
    t.integer "endereco_cep"
    t.string "endereco_logradouro"
    t.integer "endereco_numero"
    t.string "endereco_complemento"
    t.decimal "latitude", precision: 7, scale: 4
    t.decimal "longitude", precision: 7, scale: 4
    t.index ["atendimento_local_tipo_id"], name: "atendimento_local_tipo_id"
  end

  create_table "atendimento_local_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tipo", null: false
  end

  create_table "atendimento_modalidades", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "modalidade", limit: 100
  end

  create_table "atendimento_plataformas", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", limit: 50, null: false
    t.string "site", limit: 100
    t.string "descricao"
    t.decimal "taxa_fixa", precision: 10, scale: 2
    t.decimal "taxa_atendimento", precision: 10, scale: 2
  end

  create_table "atendimento_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "atendimento_valores", primary_key: "atendimento_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "valor"
    t.bigint "desconto", default: 0
    t.bigint "taxa_porcentagem_externa", default: 0
    t.integer "taxa_porcentagem_interna", default: 0
  end

  create_table "atendimentos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "data"
    t.time "horario"
    t.integer "modalidade_id", null: false
    t.integer "acompanhamento_id", null: false
    t.boolean "presenca"
    t.integer "atendimento_tipo_id"
    t.text "consideracoes", size: :medium
    t.integer "atendimento_local_id"
    t.boolean "reagendado", default: false
    t.index ["acompanhamento_id"], name: "acompanhamento_id"
    t.index ["atendimento_tipo_id"], name: "atendimento_tipo_id"
    t.index ["modalidade_id"], name: "modalidade_id"
  end

  create_table "biblioteca_autores", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome"
    t.string "nome_do_meio", limit: 1000
    t.string "sobrenome", null: false
    t.string "ordem"
    t.boolean "feminino", default: false
    t.string "link"
    t.text "bio", size: :long
  end

  create_table "biblioteca_editoras", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", null: false
    t.string "ordem"
    t.string "local"
  end

  create_table "biblioteca_identificadores", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "obra_id", null: false
    t.string "tipo", null: false
    t.string "valor", null: false
    t.index ["obra_id"], name: "obra_id"
  end

  create_table "biblioteca_obra_autor_juncoes", primary_key: ["obra_id", "autor_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "obra_id", null: false
    t.integer "autor_id", null: false
    t.index ["autor_id"], name: "biblioteca_obra_autor_juncoes_ibfk_2"
  end

  create_table "biblioteca_obra_tag_juncoes", primary_key: ["obra_id", "tag_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "obra_id", null: false
    t.integer "tag_id", null: false
    t.index ["tag_id"], name: "biblioteca_obra_tag_juncoes_ibfk_2"
  end

  create_table "biblioteca_obra_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tipo", null: false
  end

  create_table "biblioteca_obras", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "titulo", null: false
    t.string "subtitulo"
    t.integer "obra_tipo_id"
    t.integer "editora_id"
    t.string "ordem"
    t.date "data_publicacao"
    t.string "isbn", limit: 13
    t.string "caminho"
    t.boolean "obra_virtual", default: false
    t.integer "num_paginas"
    t.text "resumo"
    t.integer "edicao", default: 0, null: false
    t.integer "volume", default: 0, null: false
    t.integer "periodico_id"
    t.index ["editora_id"], name: "editora_id"
    t.index ["obra_tipo_id"], name: "obra_tipo_id"
    t.index ["periodico_id"], name: "periodico_id"
  end

  create_table "biblioteca_periodicos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", null: false
    t.string "ordem"
    t.string "local"
    t.string "url"
  end

  create_table "biblioteca_tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", null: false
  end

  create_table "civil_estados", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "estado", limit: 100, null: false
  end

  create_table "continentes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", limit: 50
  end

  create_table "crefito_regioes", primary_key: "uf_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "id", null: false
  end

  create_table "crefono_regioes", primary_key: "uf_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "id", null: false
  end

  create_table "crn_regioes", primary_key: "uf_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "id", null: false
  end

  create_table "crp_regioes", primary_key: "uf_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "id", null: false
  end

  create_table "escola_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "gasto_pagamentos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "despesa_id", null: false
    t.integer "valor", default: 0, null: false
    t.date "data"
    t.index ["despesa_id"], name: "despesa_id"
  end

  create_table "gasto_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tipo", null: false
  end

  create_table "gastos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "descricao", null: false
    t.integer "gasto_tipo_id"
    t.integer "valor", default: 0, null: false
    t.date "data"
    t.index ["gasto_tipo_id"], name: "despesa_tipo_id"
  end

  create_table "infantojuvenil_anamnese_alimentacoes", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "solida_meses"
    t.boolean "succao_boa"
    t.boolean "degluticao_boa"
    t.boolean "usou_mamadeira"
    t.integer "comida_sal_introducao_meses"
    t.integer "desmame_meses"
    t.boolean "rejeicao"
    t.integer "comer_sozinho_inicio_meses"
    t.string "comer_sozinho_inicio_alimento", limit: 500
    t.text "comportamento_mesa"
    t.boolean "precisa_ajuda"
    t.text "alimentacao_atual"
  end

  create_table "infantojuvenil_anamnese_comunicacoes", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "primeiras_silabas", limit: 100
    t.string "primeiras_palavras", limit: 100
    t.string "primeiras_frases", limit: 1000
    t.boolean "uso_eu"
    t.boolean "entendimento"
    t.string "atitudes_expressar_desejo", limit: 500
    t.string "disturbio_fala", limit: 100
    t.boolean "relata_situacoes"
    t.string "linguas_ouvidas_casa", limit: 500
  end

  create_table "infantojuvenil_anamnese_escola_historicos", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "idade_entrada_anos"
    t.integer "escola_tipo_id"
    t.text "aproveitamento"
    t.text "dificuldades"
    t.text "mudancas"
    t.text "atitudes_paciente_vida_escolar"
    t.text "atitudes_pais_dificuldades"
    t.text "participacao_pais"
    t.string "atividades_extras", limit: 500
    t.index ["escola_tipo_id"], name: "SYS_FK_2350"
  end

  create_table "infantojuvenil_anamnese_familia_historicos", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "antecedentes_doenca_mental", limit: 1000
    t.string "antecedentes_dependencia_quimica", limit: 1000
    t.string "ambiente_familiar_condicoes_economicas", limit: 1000
    t.boolean "ambiente_familiar_usuario_consciente_situacao_economica"
    t.string "ambiente_familiar_atitude_usuario_situacao_economica", limit: 1000
    t.string "ambiente_familiar_residentes_casa", limit: 1000
    t.string "ambiente_familiar_relacionamento_pais", limit: 1000
    t.string "ambiente_familiar_pais_filhos", limit: 1000
  end

  create_table "infantojuvenil_anamnese_gestacoes", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "desejada"
    t.integer "idade_pai"
    t.integer "idade_mae"
    t.integer "irmaos_mais_velhos"
    t.integer "irmaos_mais_novos"
    t.integer "gestacao_anterior_meses"
    t.integer "abortos_anteriores"
    t.text "mae_saude"
    t.date "data_pre_natal"
    t.string "mae_sensacoes", limit: 1000
    t.string "mae_internacoes", limit: 1000
    t.string "mae_enjoos", limit: 1000
    t.string "mae_vomitos", limit: 1000
    t.boolean "mae_diabetes"
    t.boolean "mae_traumatismo"
    t.boolean "mae_convulsoes"
    t.string "mae_medicamentos", limit: 1000
    t.integer "parto_local_id"
    t.integer "parto_tipo_id"
    t.integer "nascimento_peso_g"
    t.integer "nascimento_comprimento_cm"
    t.integer "gestacao_semanas"
    t.text "nascimento_crianca_condicoes"
    t.text "nascimento_reacao_pai"
    t.text "nascimento_reacao_mae"
    t.text "nascimento_reacao_irmaos"
    t.text "desenvolvimento_parto"
    t.index ["parto_local_id"], name: "SYS_FK_2300"
    t.index ["parto_tipo_id"], name: "SYS_FK_2299"
  end

  create_table "infantojuvenil_anamnese_manipulacoes", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "chupeta_usou"
    t.integer "chupeta_usou_meses"
    t.text "chupeta_relato_retirada"
    t.boolean "chupou_dedo"
    t.integer "chupou_dedo_meses"
    t.text "chupou_dedo_relato_retirada"
    t.boolean "roe_unhas"
    t.boolean "arranca_cabelos"
    t.text "outros"
    t.text "atitudes_tomadas_responsaveis"
  end

  create_table "infantojuvenil_anamnese_psicomotricidades", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "sorriu_meses"
    t.integer "dirigir_ativamente_pessoas_meses"
    t.integer "ergueu_cabeca_meses"
    t.integer "sentou_meses"
    t.integer "engatinhou_meses"
    t.integer "andou_meses"
    t.integer "denticao_meses"
    t.boolean "canhoto"
    t.integer "controle_esfincter_diurno_meses"
    t.integer "controle_esfincter_noturno_meses"
    t.integer "controle_vesical_diurno_meses"
    t.integer "controle_vesical_noturno_meses"
    t.text "ensino_controle_esfincter"
    t.text "atitude_enurese"
    t.boolean "precisa_ajuda_banheiro"
    t.boolean "toma_banho_sozinho"
    t.boolean "veste_sozinho"
    t.boolean "caia_muito"
    t.boolean "conhecimento_lateralidade"
  end

  create_table "infantojuvenil_anamnese_saude_historicos", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "doencas"
    t.text "doenca_grave_e_evolucao"
    t.boolean "acompanhamento_medico"
    t.text "medicamentos"
    t.string "visao", limit: 100
    t.string "audicao", limit: 100
    t.text "inteligencia"
    t.boolean "acidente_sofrido"
    t.text "acidente_consequencias"
  end

  create_table "infantojuvenil_anamnese_sexualidades", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "curiosidade_sexual", limit: 1000
    t.boolean "masturba"
    t.string "atitude_pais", limit: 1000
    t.string "educacao_sexual", limit: 1000
  end

  create_table "infantojuvenil_anamnese_socioafetividades", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "amizade_facil"
    t.boolean "prefere_brincar_com_amigos"
    t.boolean "prefere_brincar_com_criancas_menores"
    t.boolean "gosta_visitas"
    t.string "atividades_preferidas", limit: 1000
    t.text "comportamento_descricao"
    t.boolean "tendencia_dirigir_outros"
    t.text "tiques"
    t.text "humor"
    t.boolean "rir_chorar_facilmente"
    t.boolean "expressa_desejos"
    t.boolean "tendencia_isolamento_inatividade"
    t.boolean "repeticao_gestos_gritos_palavras"
    t.boolean "carinhoso"
    t.text "comportamentos_adequados"
    t.text "comportamentos_inadequados"
  end

  create_table "infantojuvenil_anamnese_sonos", primary_key: "infantojuvenil_anamnese_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "dorme_bem"
    t.boolean "pula"
    t.boolean "baba"
    t.boolean "range_dentes"
    t.boolean "fala_grita"
    t.boolean "sudorese"
    t.boolean "movimento_demasiado"
    t.boolean "movimentos_sem_lembrar_dia_seguinte"
    t.boolean "acorda_varias_vezes"
    t.boolean "volta_dormir_facilmente"
    t.boolean "dorme_quarto_separado_pais"
    t.string "dorme_ambiente_compartilhado_com_quem", limit: 500
    t.boolean "cama_individual"
    t.integer "dormiu_quarto_pais_meses"
    t.boolean "vai_cama_pais"
    t.string "cama_pais_atitude_pais", limit: 1000
  end

  create_table "infantojuvenil_anamneses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "atendimento_id", null: false
    t.text "motivo_consulta"
    t.string "diagnostico_preliminar", limit: 1000
    t.string "plano_tratamento", limit: 1000
    t.string "prognostico", limit: 1000
    t.index ["atendimento_id"], name: "SYS_FK_2292"
  end

  create_table "instrucao_graus", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "grau", limit: 100, null: false
  end

  create_table "instrumento_relatos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "atendimento_id"
    t.integer "instrumento_id"
    t.text "relato", size: :medium
    t.text "resultados", size: :medium
    t.text "observacoes", size: :medium
    t.index ["atendimento_id"], name: "atendimento_id"
    t.index ["instrumento_id"], name: "instrumento_id"
  end

  create_table "instrumento_subfuncao_juncoes", primary_key: ["instrumento_id", "psicologia_subfuncao_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "instrumento_id", null: false
    t.integer "psicologia_subfuncao_id", null: false
    t.index ["psicologia_subfuncao_id"], name: "psicologia_subfuncao_id"
  end

  create_table "instrumento_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "instrumentos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome"
    t.integer "instrumento_tipo_id"
    t.boolean "exclusivo_psicologo"
    t.integer "faixa_etaria_meses_inicio"
    t.integer "faixa_etaria_meses_final"
    t.string "objetivo", limit: 1000
    t.boolean "cronometrado"
    t.text "material"
    t.text "aplicacao"
    t.text "indicacao"
    t.text "particularidades"
    t.boolean "tem_na_clinica", null: false
    t.index ["instrumento_tipo_id"], name: "instrumento_tipo_id"
  end

  create_table "laudos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "interessado", limit: 500
    t.date "data_avaliacao", null: false
    t.string "finalidade", limit: 500
    t.text "demanda"
    t.date "data_inicio_avaliacao"
    t.date "data_final_avaliacao"
    t.text "tecnicas"
    t.text "analise"
    t.text "conclusao"
    t.integer "acompanhamento_id"
    t.index ["acompanhamento_id"], name: "laudos_ibfk_1"
  end

  create_table "neuropsicologico_adulto_anamneses", primary_key: "atendimento_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "escolaridade_anos"
    t.text "historico_profissional"
    t.text "aspectos_psicoemocionais"
    t.text "historico_ocupacional"
    t.text "historico_medico"
    t.text "aspectos_psicossociais"
    t.text "antecedentes_familiares"
    t.text "comorbidades"
    t.text "desenvolvimento_neuropsicomotor"
    t.text "medicacoes_em_uso"
    t.text "uso_drogas_ilicitas"
    t.text "autonomia_atividades"
    t.text "alimentacao"
    t.text "sono"
    t.text "habilidades_afetadas"
    t.string "quem_encaminhou"
    t.text "motivo_encaminhamento"
    t.string "diagnostico_preliminar", limit: 1000
    t.string "plano_tratamento", limit: 1000
    t.string "prognostico", limit: 1000
  end

  create_table "pagamento_modalidades", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "modalidade", limit: 50
  end

  create_table "paises", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome_ingles"
    t.string "nome", null: false
    t.string "nome_oficial"
    t.string "sigla_2", limit: 2, null: false
    t.string "sigla_3", limit: 3, null: false
    t.integer "iso_3166_numerico", null: false
    t.integer "continente_id"
    t.index ["continente_id"], name: "continente_id"
  end

  create_table "parentescos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "parentesco", limit: 100
  end

  create_table "parto_locais", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "local", limit: 100, null: false
  end

  create_table "parto_tipos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "descricao", limit: 100, null: false
  end

  create_table "pessoa_devolutivas", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_id"
    t.integer "pessoa_responsavel_id"
    t.integer "profissional_id"
    t.date "data"
    t.text "feedback_responsavel", size: :medium
    t.text "orientacoes_profissional", size: :medium
    t.index ["pessoa_id"], name: "usuario_id"
    t.index ["pessoa_responsavel_id"], name: "usuario_responsavel_id"
    t.index ["profissional_id"], name: "profissional_id"
  end

  create_table "pessoa_emails", primary_key: ["pessoa_id", "email"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.string "email", null: false
  end

  create_table "pessoa_extra_informacoes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.text "conteudo_material", size: :medium
    t.date "data", null: false
    t.string "meio"
    t.index ["pessoa_id"], name: "usuario_id"
  end

  create_table "pessoa_responsaveis", primary_key: ["pessoa_dependente_id", "pessoa_responsavel_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_dependente_id", null: false
    t.integer "pessoa_responsavel_id", null: false
    t.integer "parentesco_id"
    t.index ["pessoa_responsavel_id"], name: "pessoa_responsaveis_ibfk_2"
  end

  create_table "pessoa_telefones", primary_key: ["pessoa_id", "cod_area", "num", "cod_pais"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.string "cod_area", limit: 2, null: false
    t.string "num", limit: 100, null: false
    t.string "cod_pais", limit: 6, null: false
    t.string "descricao"
  end

  create_table "pessoa_tratamento_pronomes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "pronome_masculino", null: false
    t.string "pronome_feminino"
    t.string "pronome_masculino_abreviado", limit: 10
    t.string "pronome_feminino_abreviado", limit: 10
  end

  create_table "pessoas", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome"
    t.string "nome_do_meio"
    t.string "sobrenome", limit: 500
    t.string "cpf", limit: 11
    t.string "fone_cod_pais", limit: 7
    t.string "fone_cod_area", limit: 7
    t.string "fone_num", limit: 15
    t.boolean "feminino"
    t.integer "civil_estado_id"
    t.integer "instrucao_grau_id"
    t.date "data_nascimento"
    t.string "email", limit: 500, default: "nao@informado.com", null: false
    t.integer "pais_id"
    t.string "estado"
    t.string "cidade", limit: 500
    t.integer "endereco_cep"
    t.string "endereco_logradouro"
    t.integer "endereco_numero"
    t.string "endereco_complemento"
    t.string "profissao"
    t.string "preferencia_contato"
    t.string "imagem_perfil"
    t.integer "pessoa_tratamento_pronome_id"
    t.boolean "inverter_pronome_tratamento"
    t.index ["civil_estado_id"], name: "civil_estado_id"
    t.index ["instrucao_grau_id"], name: "instrucao_grau_id"
    t.index ["pais_id"], name: "pais_id"
    t.index ["pessoa_tratamento_pronome_id"], name: "pessoa_tratamento_pronome_id"
  end

  create_table "profissionais", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.integer "profissional_funcao_id"
    t.integer "documento_regiao_id"
    t.string "documento_valor"
    t.boolean "desligado", default: false
    t.text "bio", size: :medium
    t.string "chave_pix_01"
    t.string "chave_pix_02"
    t.boolean "ativo", default: true
    t.index ["pessoa_id"], name: "pessoa_id"
    t.index ["profissional_funcao_id"], name: "profissionais_ibfk_2"
  end

  create_table "profissional_documento_modelos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.string "titulo", null: false
    t.string "descricao", limit: 1000
    t.text "conteudo"
    t.string "usado_para", default: "Acompanhamento", null: false
    t.index ["profissional_id"], name: "profissional_id"
  end

  create_table "profissional_especializacao_juncoes", primary_key: ["profissional_id", "profissional_especializacao_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.integer "profissional_especializacao_id", null: false
    t.index ["profissional_especializacao_id"], name: "especializacao_id"
  end

  create_table "profissional_especializacoes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "especializacao", null: false
  end

  create_table "profissional_financeiro_repasses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.integer "valor", default: 0, null: false
    t.date "data"
    t.integer "modalidade_id", null: false
    t.index ["modalidade_id"], name: "modalidade_id"
    t.index ["profissional_id"], name: "profissional_id"
  end

  create_table "profissional_funcoes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "funcao", null: false
    t.string "orgao_responsavel"
    t.string "documento_tipo"
    t.string "flexao_feminino"
  end

  create_table "profissional_notas", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.time "data", default: -> { "(curdate())" }
    t.time "hora", default: -> { "(curtime())" }
    t.string "titulo", limit: 1000
    t.text "nota"
    t.date "data_lembrar"
    t.time "hora_lembrar"
    t.index ["profissional_id"], name: "profissional_id"
  end

  create_table "psicologia_funcoes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", limit: 100
    t.string "descricao", limit: 1000
  end

  create_table "psicologia_subfuncoes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "psicologia_funcao_id"
    t.string "nome", limit: 100
    t.string "descricao", limit: 1000
    t.index ["psicologia_funcao_id"], name: "psicologia_funcao_id"
  end

  create_table "reajuste_motivos", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "motivo", limit: 100, null: false
  end

  create_table "reajustes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "acompanhamento_id", null: false
    t.date "data_ajuste", null: false
    t.integer "valor_novo"
    t.date "data_negociacao"
    t.integer "reajuste_motivo_id"
    t.index ["acompanhamento_id"], name: "acompanhamento_id"
    t.index ["reajuste_motivo_id"], name: "reajuste_motivo_id"
  end

  create_table "recebimentos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "pessoa_pagante_id"
    t.integer "acompanhamento_id", null: false
    t.bigint "valor", default: 0, null: false
    t.date "data", default: -> { "(curdate())" }, null: false
    t.integer "modalidade_id", default: 1, null: false
    t.index ["acompanhamento_id"], name: "acompanhamento_id"
    t.index ["modalidade_id"], name: "modalidade_id"
    t.index ["pessoa_pagante_id"], name: "pessoa_pagante_id"
  end

  create_table "relatos", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "relato"
  end

  create_table "subtestes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "instrumento_id"
    t.integer "psicologia_subfuncao_id"
    t.string "descricao", limit: 100
    t.integer "tempo_conclusao_segundos"
    t.text "itens"
  end

  create_table "ufs", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.string "sigla", limit: 2, null: false
  end

  create_table "usuarios", primary_key: "profissional_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false
    t.boolean "corpo_clinico", default: false
    t.boolean "secretaria", default: false
    t.boolean "financeiro", default: false
    t.boolean "informatica", default: false
  end

  add_foreign_key "acompanhamentos", "acompanhamento_finalizacao_motivos", column: "finalizacao_motivo_id", name: "acompanhamentos_ibfk_2", on_update: :cascade
  add_foreign_key "acompanhamentos", "acompanhamento_tipos", name: "acompanhamentos_ibfk_1", on_update: :cascade
  add_foreign_key "acompanhamentos", "atendimento_plataformas", column: "plataforma_id", name: "acompanhamentos_ibfk_3", on_update: :cascade
  add_foreign_key "acompanhamentos", "pessoas", column: "pessoa_responsavel_id", name: "acompanhamentos_ibfk_6", on_update: :cascade
  add_foreign_key "acompanhamentos", "pessoas", name: "acompanhamentos_ibfk_5", on_update: :cascade
  add_foreign_key "acompanhamentos", "profissionais", name: "acompanhamentos_ibfk_4", on_update: :cascade
  add_foreign_key "atendimento_locais", "atendimento_local_tipos", name: "atendimento_locais_ibfk_1", on_update: :cascade
  add_foreign_key "atendimento_valores", "atendimentos", name: "atendimento_valores_ibfk_1", on_update: :cascade
  add_foreign_key "atendimentos", "acompanhamentos", name: "atendimentos_ibfk_1", on_update: :cascade
  add_foreign_key "atendimentos", "atendimento_modalidades", column: "modalidade_id", name: "atendimentos_ibfk_3", on_update: :cascade
  add_foreign_key "atendimentos", "atendimento_tipos", name: "atendimentos_ibfk_2", on_update: :cascade
  add_foreign_key "biblioteca_identificadores", "biblioteca_obras", column: "obra_id", name: "biblioteca_identificadores_ibfk_1"
  add_foreign_key "biblioteca_obra_autor_juncoes", "biblioteca_autores", column: "autor_id", name: "biblioteca_obra_autor_juncoes_ibfk_2", on_update: :cascade
  add_foreign_key "biblioteca_obra_autor_juncoes", "biblioteca_obras", column: "obra_id", name: "biblioteca_obra_autor_juncoes_ibfk_1", on_update: :cascade
  add_foreign_key "biblioteca_obra_tag_juncoes", "biblioteca_obras", column: "obra_id", name: "biblioteca_obra_tag_juncoes_ibfk_1", on_update: :cascade
  add_foreign_key "biblioteca_obra_tag_juncoes", "biblioteca_tags", column: "tag_id", name: "biblioteca_obra_tag_juncoes_ibfk_2", on_update: :cascade
  add_foreign_key "biblioteca_obras", "biblioteca_editoras", column: "editora_id", name: "biblioteca_obras_ibfk_2"
  add_foreign_key "biblioteca_obras", "biblioteca_obra_tipos", column: "obra_tipo_id", name: "biblioteca_obras_ibfk_1"
  add_foreign_key "biblioteca_obras", "biblioteca_periodicos", column: "periodico_id", name: "biblioteca_obras_ibfk_3", on_update: :cascade
  add_foreign_key "gasto_pagamentos", "gastos", column: "despesa_id", name: "gasto_pagamentos_ibfk_1"
  add_foreign_key "gastos", "gasto_tipos", name: "gastos_ibfk_1"
  add_foreign_key "infantojuvenil_anamnese_alimentacoes", "infantojuvenil_anamneses", name: "SYS_FK_2392", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_comunicacoes", "infantojuvenil_anamneses", name: "SYS_FK_2324", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_escola_historicos", "escola_tipos", name: "SYS_FK_2350", on_update: :cascade
  add_foreign_key "infantojuvenil_anamnese_escola_historicos", "infantojuvenil_anamneses", name: "SYS_FK_2349", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_familia_historicos", "infantojuvenil_anamneses", name: "SYS_FK_2344", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_gestacoes", "infantojuvenil_anamneses", name: "SYS_FK_2298", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_gestacoes", "parto_locais", name: "SYS_FK_2300", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_gestacoes", "parto_tipos", name: "SYS_FK_2299", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_manipulacoes", "infantojuvenil_anamneses", name: "SYS_FK_2329", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_psicomotricidades", "infantojuvenil_anamneses", name: "SYS_FK_2309", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_saude_historicos", "infantojuvenil_anamneses", name: "SYS_FK_2334", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_sexualidades", "infantojuvenil_anamneses", name: "SYS_FK_2339", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_socioafetividades", "infantojuvenil_anamneses", name: "SYS_FK_2319", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_sonos", "infantojuvenil_anamneses", name: "SYS_FK_2314", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamneses", "atendimentos", name: "SYS_FK_2292", on_update: :cascade, on_delete: :cascade
  add_foreign_key "instrumento_relatos", "atendimentos", name: "instrumento_relatos_ibfk_1", on_update: :cascade
  add_foreign_key "instrumento_relatos", "instrumentos", name: "instrumento_relatos_ibfk_2", on_update: :cascade
  add_foreign_key "instrumento_subfuncao_juncoes", "instrumentos", name: "instrumento_subfuncao_juncoes_ibfk_1", on_update: :cascade
  add_foreign_key "instrumento_subfuncao_juncoes", "psicologia_subfuncoes", name: "instrumento_subfuncao_juncoes_ibfk_2", on_update: :cascade
  add_foreign_key "instrumentos", "instrumento_tipos", name: "instrumentos_ibfk_1", on_update: :cascade, on_delete: :nullify
  add_foreign_key "laudos", "acompanhamentos", name: "laudos_ibfk_1", on_update: :cascade
  add_foreign_key "neuropsicologico_adulto_anamneses", "atendimentos", name: "neuropsicologico_adulto_anamneses_ibfk_1", on_update: :cascade
  add_foreign_key "paises", "continentes", name: "paises_ibfk_1", on_update: :cascade
  add_foreign_key "pessoa_devolutivas", "pessoas", column: "pessoa_responsavel_id", name: "pessoa_devolutivas_ibfk_5", on_update: :cascade
  add_foreign_key "pessoa_devolutivas", "pessoas", column: "pessoa_responsavel_id", name: "pessoa_devolutivas_ibfk_7", on_update: :cascade
  add_foreign_key "pessoa_devolutivas", "pessoas", column: "profissional_id", name: "pessoa_devolutivas_ibfk_8", on_update: :cascade
  add_foreign_key "pessoa_devolutivas", "pessoas", name: "pessoa_devolutivas_ibfk_4", on_update: :cascade
  add_foreign_key "pessoa_devolutivas", "pessoas", name: "pessoa_devolutivas_ibfk_6", on_update: :cascade
  add_foreign_key "pessoa_devolutivas", "profissionais", name: "pessoa_devolutivas_ibfk_3", on_update: :cascade
  add_foreign_key "pessoa_extra_informacoes", "pessoas", name: "pessoa_extra_informacoes_ibfk_1", on_update: :cascade
  add_foreign_key "pessoas", "civil_estados", name: "pessoas_ibfk_1"
  add_foreign_key "pessoas", "instrucao_graus", name: "pessoas_ibfk_2"
  add_foreign_key "pessoas", "paises", name: "pessoas_ibfk_3"
  add_foreign_key "pessoas", "pessoa_tratamento_pronomes", name: "pessoas_ibfk_4", on_update: :cascade
  add_foreign_key "profissionais", "profissional_funcoes", name: "profissionais_ibfk_2", on_update: :cascade, on_delete: :nullify
  add_foreign_key "profissional_documento_modelos", "profissionais", name: "profissional_documento_modelos_ibfk_1", on_update: :cascade
  add_foreign_key "profissional_especializacao_juncoes", "especializacoes", column: "profissional_especializacao_id", name: "profissional_especializacao_juncoes_ibfk_1", on_update: :cascade
  add_foreign_key "profissional_especializacao_juncoes", "profissionais", name: "profissional_especializacao_juncoes_ibfk_2", on_update: :cascade
  add_foreign_key "profissional_financeiro_repasses", "pagamento_modalidades", column: "modalidade_id", name: "profissional_financeiro_repasses_ibfk_2"
  add_foreign_key "profissional_financeiro_repasses", "profissionais", name: "profissional_financeiro_repasses_ibfk_1", on_update: :cascade
  add_foreign_key "profissional_notas", "profissionais", name: "profissional_notas_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "psicologia_subfuncoes", "psicologia_funcoes", name: "psicologia_subfuncoes_ibfk_1", on_update: :cascade
  add_foreign_key "reajustes", "acompanhamentos", name: "reajustes_ibfk_1", on_update: :cascade
  add_foreign_key "reajustes", "reajuste_motivos", name: "reajustes_ibfk_2", on_update: :cascade
  add_foreign_key "recebimentos", "acompanhamentos", name: "recebimentos_ibfk_6", on_update: :cascade
  add_foreign_key "recebimentos", "pagamento_modalidades", column: "modalidade_id", name: "recebimentos_ibfk_2", on_update: :cascade
  add_foreign_key "recebimentos", "pessoas", column: "pessoa_pagante_id", name: "recebimentos_ibfk_5", on_update: :cascade
  add_foreign_key "relatos", "atendimentos", column: "id", name: "SYS_FK_1294", on_update: :cascade, on_delete: :cascade
  add_foreign_key "usuarios", "profissionais", name: "usuarios_ibfk_1", on_update: :cascade
end
