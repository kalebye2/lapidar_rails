json.extract! pessoa, :identificador_unico, :nome_completo, *pessoa.attribute_names
json.url pessoa_url(pessoa, format: :json)
