json.extract! biblioteca_obra, :id, :titulo, :subtitulo, :biblioteca_obra_tipo_id, :biblioteca_editora_id_id, :ordem, :data_publicacao, :isbn, :caminho, :obra_virtual, :num_paginas, :resumo, :edicao, :volume, :biblioteca_periodico_id, :created_at, :updated_at
json.url biblioteca_obra_url(biblioteca_obra, format: :json)
