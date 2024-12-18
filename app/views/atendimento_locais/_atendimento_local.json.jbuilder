# json.extract! atendimento_local, :id, :atendimento_local_tipo_id, :descricao, :pais_id, :endereco_estado, :endereco_cidade, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :latitude, :longitude, :created_at, :updated_at
json.extract! atendimento_local, :id, :tipo, :descricao, :endereco_completo, :latitude, :longitude
json.url atendimento_local_url(atendimento_local)
