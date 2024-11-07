json.extract! instrumento, :id, :nome, :sigla, :instrumento_tipo, :exclusivo_psicologo, :faixa_etaria_meses_inicio, :faixa_etaria_meses_final, :objetivo, :cronometrado, :material, :aplicacao, :indicacao, :particularidades, :tem_na_clinica
json.url instrumento_url(instrumento, format: :json)
