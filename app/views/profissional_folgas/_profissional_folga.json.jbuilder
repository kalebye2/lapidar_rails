# json.extract! profissional_folga, :id, :profissional, :data_inicio, :data_final, :profissional_folga_motivo
json.extract! profissional_folga, :id, :data_inicio, :data_final, :motivo
json.profissional profissional_folga.profissional, :id, :nome_completo, :cpf, :rg, :documento, :funcao, :servico
json.url profissional_folga_url(profissional_folga, format: :json)
