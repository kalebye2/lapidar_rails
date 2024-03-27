json.extract! atendimento_local, :id, :atendimento_local_tipo_id, :descricao, :pais_id, :estado, :cidade, :endereco_cep, :endereco_logradouro, :endereco_numero, :endereco_complemento, :latitude, :longitude, :created_at, :updated_at
json.url atendimento_local_url(atendimento_local, format: :json)
