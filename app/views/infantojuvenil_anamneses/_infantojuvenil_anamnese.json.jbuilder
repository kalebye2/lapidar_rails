# json.extract! infantojuvenil_anamnese, *infantojuvenil_anamnese.attribute_names
json.id infantojuvenil_anamnese.id

json.paciente infantojuvenil_anamnese.pessoa, :nome_completo, *infantojuvenil_anamnese.pessoa.attribute_names
json.responsavel infantojuvenil_anamnese.pessoa_responsavel, :nome_completo, *infantojuvenil_anamnese.pessoa_responsavel.attribute_names
json.profissional infantojuvenil_anamnese.profissional, :id, :nome_completo, :documento, :funcao, :email, :render_fone_link, :cpf
json.servico_procurado infantojuvenil_anamnese.acompanhamento_tipo&.tipo&.capitalize

json.extract! infantojuvenil_anamnese, :data, :motivo_consulta

infantojuvenil_anamnese.class.subitens.each do |subitem|
  json.set! subitem, infantojuvenil_anamnese.send(subitem)
end

json.extract! infantojuvenil_anamnese, :diagnostico_preliminar, :plano_tratamento, :prognostico
