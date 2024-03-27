json.extract! instrumento, :id, :nome, :instrumento_tipo_id, :exclusivo_psicologo, :faixa_etaria_meses_inicio, :faixa_etaria_meses_final, :objetivo, :cronometrado, :material, :aplicacao, :indicacao, :particularidades, :tem_na_clinica, :created_at, :updated_at
json.url instrumento_url(instrumento, format: :json)
