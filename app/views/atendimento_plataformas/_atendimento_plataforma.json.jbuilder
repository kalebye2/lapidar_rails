json.extract! atendimento_plataforma, :id, :nome, :site, :descricao, :taxa_fixa, :taxa_atendimento, :created_at, :updated_at
json.url atendimento_plataforma_url(atendimento_plataforma, format: :json)
