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
  create_table "acompanhamento_finalizacao_motivos", force: :cascade do |t|
    t.string "motivo", limit: 100
  end

  create_table "acompanhamento_tipos", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "acompanhamentos", force: :cascade do |t|
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
    t.boolean "menor_de_idade", default: false
    t.integer "pessoa_responsavel_id"
    t.integer "sessoes_previstas"
  end

  create_table "atendimento_locais", force: :cascade do |t|
    t.integer "atendimento_local_tipo_id", null: false
    t.string "descricao", null: false
    t.integer "pais_id"
    t.string "estado"
    t.string "cidade"
    t.integer "endereco_cep"
    t.string "endereco_logradouro"
    t.integer "endereco_numero"
    t.string "endereco_complemento"
    t.decimal "latitude"
    t.decimal "longitude"
  end

  create_table "atendimento_local_tipos", force: :cascade do |t|
    t.string "tipo", null: false
  end

  create_table "atendimento_modalidades", force: :cascade do |t|
    t.string "modalidade", limit: 100
  end

  create_table "atendimento_plataformas", force: :cascade do |t|
    t.string "nome", limit: 50, null: false
    t.string "site", limit: 100
    t.string "descricao"
    t.decimal "taxa_fixa"
    t.decimal "taxa_atendimento"
  end

  create_table "atendimento_tipos", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "atendimento_valores", id: false, force: :cascade do |t|
    t.integer "atendimento_id", null: false
    t.integer "valor"
    t.integer "desconto", default: 0
    t.integer "taxa_porcentagem_externa", default: 0
    t.integer "taxa_porcentagem_interna", default: 0
  end

  create_table "atendimentos", force: :cascade do |t|
    t.date "data"
    t.time "horario"
    t.integer "modalidade_id", null: false
    t.integer "acompanhamento_id", null: false
    t.boolean "presenca"
    t.integer "atendimento_tipo_id"
    t.text "anotacoes"
    t.integer "atendimento_local_id"
    t.boolean "reagendado", default: false
    t.time "horario_fim"
    t.text "avancos"
    t.text "limitacoes"
  end

  create_table "biblioteca_autores", force: :cascade do |t|
    t.string "nome"
    t.string "nome_do_meio", limit: 1000
    t.string "sobrenome", null: false
    t.string "ordem"
    t.boolean "feminino", default: false
    t.string "link"
    t.text "bio"
  end

  create_table "biblioteca_editoras", force: :cascade do |t|
    t.string "nome", null: false
    t.string "ordem"
    t.string "local"
  end

  create_table "biblioteca_identificadores", force: :cascade do |t|
    t.integer "obra_id", null: false
    t.string "tipo", null: false
    t.string "valor", null: false
  end

  create_table "biblioteca_obra_autor_juncoes", primary_key: ["obra_id", "autor_id"], force: :cascade do |t|
    t.integer "obra_id", null: false
    t.integer "autor_id", null: false
    t.integer "ordem", null: false
  end

  create_table "biblioteca_obra_tag_juncoes", primary_key: ["obra_id", "tag_id"], force: :cascade do |t|
    t.integer "obra_id", null: false
    t.integer "tag_id", null: false
    t.integer "ordem", null: false
  end

  create_table "biblioteca_obra_tipos", force: :cascade do |t|
    t.string "tipo", null: false
  end

  create_table "biblioteca_obras", force: :cascade do |t|
    t.string "titulo", null: false
    t.string "subtitulo"
    t.integer "obra_tipo_id"
    t.integer "editora_id"
    t.string "ordem"
    t.date "data_publicacao"
    t.string "isbn"
    t.string "caminho"
    t.boolean "obra_virtual", default: false
    t.integer "num_paginas"
    t.text "resumo"
    t.integer "edicao", default: 0, null: false
    t.integer "volume", default: 0, null: false
    t.integer "periodico_id"
  end

  create_table "biblioteca_periodicos", force: :cascade do |t|
    t.string "nome", null: false
    t.string "ordem"
    t.string "local"
    t.string "url"
  end

  create_table "biblioteca_tags", force: :cascade do |t|
    t.string "nome", null: false
  end

  create_table "civil_estados", force: :cascade do |t|
    t.string "estado", limit: 100, null: false
  end

  create_table "continentes", force: :cascade do |t|
    t.string "nome", limit: 50
  end

  create_table "crefito_regioes", id: false, force: :cascade do |t|
    t.integer "uf_id", null: false
    t.integer "id"
  end

  create_table "crefono_regioes", id: false, force: :cascade do |t|
    t.integer "uf_id", null: false
    t.integer "id"
  end

  create_table "crn_regioes", id: false, force: :cascade do |t|
    t.integer "uf_id", null: false
    t.integer "id"
  end

  create_table "crp_regioes", id: false, force: :cascade do |t|
    t.integer "uf_id", null: false
    t.integer "id"
  end

  create_table "despesas", force: :cascade do |t|
    t.integer "valor", default: 0, null: false
    t.date "data"
    t.string "descricao", default: "Gastos comuns", null: false
  end

  create_table "escola_tipos", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "gasto_pagamentos", force: :cascade do |t|
    t.integer "despesa_id", null: false
    t.integer "valor", default: 0, null: false
    t.date "data"
  end

  create_table "gasto_tipos", force: :cascade do |t|
    t.string "tipo", null: false
  end

  create_table "gastos", force: :cascade do |t|
    t.string "descricao", null: false
    t.integer "gasto_tipo_id"
    t.integer "valor", default: 0, null: false
    t.date "data"
  end

  create_table "infantojuvenil_anamnese_alimentacoes", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.integer "solida_meses"
    t.integer "succao_boa"
    t.integer "degluticao_boa"
    t.integer "usou_mamadeira"
    t.integer "comida_sal_introducao_meses"
    t.integer "desmame_meses"
    t.integer "rejeicao"
    t.integer "comer_sozinho_inicio_meses"
    t.string "comer_sozinho_inicio_alimento", limit: 500
    t.text "comportamento_mesa"
    t.integer "precisa_ajuda"
    t.text "alimentacao_atual"
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_comunicacoes", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.string "primeiras_silabas", limit: 100
    t.string "primeiras_palavras", limit: 100
    t.string "primeiras_frases", limit: 1000
    t.integer "uso_eu"
    t.integer "entendimento"
    t.string "atitudes_expressar_desejo", limit: 500
    t.string "disturbio_fala", limit: 100
    t.integer "relata_situacoes"
    t.string "linguas_ouvidas_casa", limit: 500
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_escola_historicos", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.integer "idade_entrada_anos"
    t.integer "escola_tipo_id"
    t.text "aproveitamento"
    t.text "dificuldades"
    t.text "mudancas"
    t.text "atitudes_paciente_vida_escolar"
    t.text "atitudes_pais_dificuldades"
    t.text "participacao_pais"
    t.string "atividades_extras", limit: 500
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_familia_historicos", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.string "antecedentes_doenca_mental", limit: 1000
    t.string "antecedentes_dependencia_quimica", limit: 1000
    t.string "ambiente_familiar_condicoes_economicas", limit: 1000
    t.integer "ambiente_familiar_pessoa_consciente_situacao_economica"
    t.string "ambiente_familiar_atitude_pessoa_situacao_economica", limit: 1000
    t.string "ambiente_familiar_residentes_casa", limit: 1000
    t.string "ambiente_familiar_relacionamento_pais", limit: 1000
    t.string "ambiente_familiar_pais_filhos", limit: 1000
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_gestacoes", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.integer "desejada"
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
    t.integer "mae_diabetes"
    t.integer "mae_traumatismo"
    t.integer "mae_convulsoes"
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
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_manipulacoes", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.integer "chupeta_usou"
    t.integer "chupeta_usou_meses"
    t.text "chupeta_relato_retirada"
    t.integer "chupou_dedo"
    t.integer "chupou_dedo_meses"
    t.text "chupou_dedo_relato_retirada"
    t.integer "roi_unhas"
    t.integer "arranca_cabelos"
    t.text "outros"
    t.text "atitudes_tomadas_responsaveis"
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_psicomotricidades", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.integer "sorriu_meses"
    t.integer "dirigir_ativamente_pessoas_meses"
    t.integer "ergueu_cabeca_meses"
    t.integer "sentou_meses"
    t.integer "engatinhou_meses"
    t.integer "andou_meses"
    t.integer "denticao_meses"
    t.integer "canhoto"
    t.integer "controle_esfincter_diurno_meses"
    t.integer "controle_esfincter_noturno_meses"
    t.integer "controle_vesical_diurno_meses"
    t.integer "controle_vesical_noturno_meses"
    t.text "ensino_controle_esfincter"
    t.text "atitude_enurese"
    t.integer "precisa_ajuda_banheiro"
    t.integer "toma_banho_sozinho"
    t.integer "veste_sozinho"
    t.integer "caia_muito"
    t.integer "conhecimento_lateralidade"
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_saude_historicos", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.text "doencas"
    t.text "doenca_grave_e_evolucao"
    t.integer "acompanhamento_medico"
    t.text "medicamentos"
    t.string "visao", limit: 100
    t.string "audicao", limit: 100
    t.text "inteligencia"
    t.integer "acidente_sofrido"
    t.text "acidente_consequencias"
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_sexualidades", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.string "curiosidade_sexual", limit: 1000
    t.integer "masturba"
    t.string "atitude_pais", limit: 1000
    t.string "educacao_sexual", limit: 1000
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_socioafetividades", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.integer "amizade_facil"
    t.integer "prefere_brincar_com_amigos"
    t.integer "prefere_brincar_com_criancas_menores"
    t.integer "gosta_visitas"
    t.string "atividades_preferidas", limit: 1000
    t.text "comportamento_descricao"
    t.integer "tendencia_dirigir_outros"
    t.text "tiques"
    t.text "humor"
    t.integer "rir_chorar_facilmente"
    t.integer "expressa_desejos"
    t.integer "tendencia_isolamento_inatividade"
    t.integer "repeticao_gestos_gritos_palavras"
    t.integer "carinhoso"
    t.text "comportamentos_adequados"
    t.text "comportamentos_inadequados"
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamnese_sonos", id: false, force: :cascade do |t|
    t.integer "infantojuvenil_anamnese_id", null: false
    t.integer "dorme_bem"
    t.integer "pula"
    t.integer "baba"
    t.integer "range_dentes"
    t.integer "fala_grita"
    t.integer "sudorese"
    t.integer "movimento_demasiado"
    t.integer "movimentos_sem_lembrar_dia_seguinte"
    t.integer "acorda_varias_vezes"
    t.integer "volta_dormir_facilmente"
    t.integer "dorme_quarto_separado_pais"
    t.string "dorme_ambiente_compartilhado_com_quem", limit: 500
    t.integer "cama_individual"
    t.integer "dormiu_quarto_pais_meses"
    t.integer "vai_cama_pais"
    t.string "cama_pais_atitude_pais", limit: 1000
    t.text "outras_consideracoes"
  end

  create_table "infantojuvenil_anamneses", force: :cascade do |t|
    t.integer "atendimento_id", null: false
    t.text "motivo_consulta"
    t.string "diagnostico_preliminar", limit: 1000
    t.string "plano_tratamento", limit: 1000
    t.string "prognostico", limit: 1000
  end

  create_table "instrucao_graus", force: :cascade do |t|
    t.string "grau", limit: 100, null: false
  end

  create_table "instrumento_relatos", force: :cascade do |t|
    t.integer "atendimento_id"
    t.integer "instrumento_id"
    t.text "relato"
    t.text "resultados"
    t.text "observacoes"
  end

  create_table "instrumento_subfuncao_juncoes", primary_key: ["instrumento_id", "psicologia_subfuncao_id"], force: :cascade do |t|
    t.integer "instrumento_id", null: false
    t.integer "psicologia_subfuncao_id", null: false
  end

  create_table "instrumento_tipos", force: :cascade do |t|
    t.string "tipo", limit: 100
  end

  create_table "instrumentos", force: :cascade do |t|
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
  end

  create_table "laudos", force: :cascade do |t|
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
    t.text "referencias"
    t.integer "fechado", default: 0
  end

  create_table "neuropsicologico_adulto_anamneses", id: false, force: :cascade do |t|
    t.integer "atendimento_id", null: false
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

  create_table "pagamento_modalidades", force: :cascade do |t|
    t.string "modalidade", limit: 50
  end

  create_table "paises", force: :cascade do |t|
    t.string "nome_ingles"
    t.string "nome", null: false
    t.string "nome_oficial"
    t.string "sigla_2", limit: 2, null: false
    t.string "sigla_3", limit: 3, null: false
    t.integer "iso_3166_numerico", null: false
    t.integer "continente_id"
  end

  create_table "parentescos", force: :cascade do |t|
    t.string "parentesco", limit: 100
  end

  create_table "parto_locais", force: :cascade do |t|
    t.string "local", limit: 100, null: false
  end

  create_table "parto_tipos", force: :cascade do |t|
    t.string "tipo", limit: 100, null: false
  end

  create_table "pessoa_devolutivas", force: :cascade do |t|
    t.integer "pessoa_id"
    t.integer "pessoa_responsavel_id"
    t.integer "profissional_id"
    t.date "data"
    t.text "pontos_a_abordar"
    t.text "feedback_responsavel"
    t.text "orientacoes_profissional"
  end

  create_table "pessoa_emails", id: false, force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.string "email", limit: 255, null: false
  end

  create_table "pessoa_etnias", force: :cascade do |t|
    t.string "etnia", limit: 255
  end

  create_table "pessoa_responsaveis", id: false, force: :cascade do |t|
    t.integer "pessoa_dependente_id", null: false
    t.integer "pessoa_responsavel_id", null: false
    t.integer "parentesco_id"
  end

  create_table "pessoa_telefones", id: false, force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.string "cod_area", limit: 2, null: false
    t.string "num", limit: 100, null: false
    t.string "cod_pais", limit: 6, null: false
    t.string "descricao", limit: 255
  end

  create_table "pessoa_tratamento_pronomes", force: :cascade do |t|
    t.string "pronome_masculino", limit: 255, null: false
    t.string "pronome_feminino", limit: 255
    t.string "pronome_masculino_abreviado", limit: 10
    t.string "pronome_feminino_abreviado", limit: 10
  end

  create_table "pessoas", force: :cascade do |t|
    t.string "nome", limit: 255
    t.string "nome_do_meio", limit: 255
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
    t.string "estado", limit: 255
    t.string "cidade", limit: 500
    t.integer "endereco_cep"
    t.string "endereco_logradouro", limit: 255
    t.integer "endereco_numero"
    t.string "endereco_complemento", limit: 255
    t.string "profissao", limit: 255
    t.string "preferencia_contato", limit: 255
    t.string "imagem_perfil", limit: 255
    t.integer "pessoa_tratamento_pronome_id"
    t.boolean "inverter_pronome_tratamento"
    t.string "orientacao_sexual", limit: 255
    t.integer "nascimento_pais_id"
    t.string "nome_preferido", limit: 255
  end

  create_table "profissionais", force: :cascade do |t|
    t.integer "pessoa_id", null: false
    t.integer "profissional_funcao_id"
    t.integer "documento_regiao_id"
    t.string "documento_valor", limit: 255
    t.boolean "desligado", default: false
    t.text "bio"
    t.string "chave_pix_01", limit: 255
    t.string "chave_pix_02", limit: 255
    t.boolean "ativo", default: true
  end

  create_table "profissional_documento_modelos", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.string "titulo", limit: 255, null: false
    t.string "descricao", limit: 1000
    t.text "conteudo"
    t.string "usado_para", limit: 255, default: "Acompanhamento", null: false
    t.string "tamanho_papel", limit: 255
  end

  create_table "profissional_especializacao_juncoes", primary_key: ["profissional_id", "profissional_especializacao_id"], force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.integer "profissional_especializacao_id", null: false
  end

  create_table "profissional_especializacoes", force: :cascade do |t|
    t.string "especializacao", limit: 255, null: false
  end

  create_table "profissional_financeiro_repasses", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.integer "valor", default: 0, null: false
    t.date "data"
    t.integer "modalidade_id", null: false
  end

  create_table "profissional_funcoes", force: :cascade do |t|
    t.string "funcao", limit: 255, null: false
    t.string "orgao_responsavel", limit: 255
    t.string "documento_tipo", limit: 255
    t.string "flexao_feminino", limit: 255
    t.string "servico", limit: 255
    t.string "adjetivo_masc", limit: 255
    t.string "adjetivo_fem", limit: 255
  end

  create_table "profissional_notas", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.date "data", default: -> { "CURRENT_DATE" }
    t.time "hora", default: -> { "CURRENT_TIME" }
    t.string "titulo", limit: 1000
    t.text "nota"
    t.date "data_lembrar"
    t.time "hora_lembrar"
  end

  create_table "psicologia_funcoes", force: :cascade do |t|
    t.string "nome", limit: 100
    t.string "descricao", limit: 1000
  end

  create_table "psicologia_subfuncoes", force: :cascade do |t|
    t.integer "psicologia_funcao_id"
    t.string "nome", limit: 100
    t.string "descricao", limit: 1000
  end

  create_table "reajuste_motivos", force: :cascade do |t|
    t.string "motivo", limit: 100, null: false
  end

  create_table "reajustes", force: :cascade do |t|
    t.integer "acompanhamento_id", null: false
    t.date "data_ajuste", null: false
    t.integer "valor_novo"
    t.date "data_negociacao"
    t.integer "reajuste_motivo_id"
  end

  create_table "recebimentos", force: :cascade do |t|
    t.integer "pessoa_pagante_id"
    t.integer "acompanhamento_id", null: false
    t.integer "valor", default: 0, null: false
    t.date "data", default: -> { "CURRENT_DATE" }, null: false
    t.integer "modalidade_id", default: 1, null: false
  end

  create_table "subtestes", force: :cascade do |t|
    t.integer "instrumento_id"
    t.integer "psicologia_subfuncao_id"
    t.string "descricao", limit: 100
    t.integer "tempo_conclusao_segundos"
    t.text "itens"
  end

  create_table "ufs", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.string "sigla", limit: 2, null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.integer "profissional_id", null: false
    t.string "username", limit: 255, null: false
    t.string "password_digest", limit: 255, null: false
    t.boolean "admin", default: false
    t.boolean "corpo_clinico", default: false
    t.boolean "secretaria", default: false
    t.boolean "financeiro", default: false
    t.boolean "informatica", default: false
  end

  add_foreign_key "acompanhamentos", "acompanhamento_tipos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "acompanhamentos", "atendimento_plataformas", column: "plataforma_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "acompanhamentos", "atendimento_plataformas", column: "plataforma_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "acompanhamentos", "pessoas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "acompanhamentos", "profissionais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimento_locais", "atendimento_local_tipos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimento_locais", "paises", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimento_valores", "atendimentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimentos", "acompanhamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimentos", "acompanhamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimentos", "atendimento_locais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimentos", "atendimento_modalidades", column: "modalidade_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "atendimentos", "atendimento_tipos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biblioteca_identificadores", "biblioteca_obras", column: "obra_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biblioteca_obra_autor_juncoes", "biblioteca_autores", column: "autor_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biblioteca_obra_autor_juncoes", "biblioteca_obras", column: "obra_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biblioteca_obra_tag_juncoes", "biblioteca_obras", column: "obra_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biblioteca_obra_tag_juncoes", "biblioteca_tags", column: "tag_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biblioteca_obras", "biblioteca_obra_tipos", column: "obra_tipo_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biblioteca_obras", "biblioteca_periodicos", column: "periodico_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "crefito_regioes", "ufs", on_update: :cascade, on_delete: :cascade
  add_foreign_key "crefono_regioes", "ufs", on_update: :cascade, on_delete: :cascade
  add_foreign_key "crn_regioes", "ufs", on_update: :cascade, on_delete: :cascade
  add_foreign_key "crp_regioes", "ufs", on_update: :cascade, on_delete: :cascade
  add_foreign_key "gasto_pagamentos", "despesas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "gastos", "gasto_tipos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_alimentacoes", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_comunicacoes", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_escola_historicos", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_familia_historicos", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_gestacoes", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_manipulacoes", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_psicomotricidades", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_saude_historicos", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_sexualidades", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_socioafetividades", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamnese_sonos", "infantojuvenil_anamneses", on_update: :cascade, on_delete: :cascade
  add_foreign_key "infantojuvenil_anamneses", "atendimentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "instrumento_relatos", "atendimentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "instrumento_relatos", "instrumentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "instrumento_subfuncao_juncoes", "instrumentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "instrumento_subfuncao_juncoes", "psicologia_subfuncoes", on_update: :cascade, on_delete: :cascade
  add_foreign_key "instrumentos", "instrumento_tipos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "laudos", "acompanhamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "neuropsicologico_adulto_anamneses", "atendimentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoa_devolutivas", "pessoas", column: "pessoa_responsavel_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoa_devolutivas", "pessoas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoa_devolutivas", "profissionais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoa_emails", "pessoas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoa_responsaveis", "pessoas", column: "pessoa_dependente_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoa_responsaveis", "pessoas", column: "pessoa_responsavel_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoa_telefones", "pessoas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoas", "civil_estados", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoas", "instrucao_graus", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoas", "paises", column: "nascimento_pais_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pessoas", "paises", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissionais", "pessoas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissionais", "profissional_funcoes", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissionais", "profissional_funcoes", on_update: :cascade, on_delete: :nullify
  add_foreign_key "profissional_documento_modelos", "profissionais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissional_especializacao_juncoes", "profissionais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissional_especializacao_juncoes", "profissionais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissional_especializacao_juncoes", "profissional_especializacaos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissional_especializacao_juncoes", "profissional_especializacoes", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissional_financeiro_repasses", "profissionais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profissional_notas", "profissionais", on_update: :cascade, on_delete: :cascade
  add_foreign_key "psicologia_subfuncoes", "psicologia_funcoes", on_update: :cascade, on_delete: :cascade
  add_foreign_key "reajustes", "acompanhamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "reajustes", "reajuste_motivos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "recebimentos", "acompanhamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "recebimentos", "pagamento_modalidades", column: "modalidade_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "recebimentos", "pessoas", column: "pessoa_pagante_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "subtestes", "instrumentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "subtestes", "psicologia_subfuncoes", on_update: :cascade, on_delete: :cascade
  add_foreign_key "usuarios", "profissionais", on_update: :cascade, on_delete: :cascade
end
