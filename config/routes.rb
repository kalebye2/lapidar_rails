Rails.application.routes.draw do
  resources :biblioteca_autores
  resources :pessoa_medicacoes
  scope :estatisticas do
    get '/', to: 'estatisticas#index', as: "estatisticas"
    get "/clinica", to: "estatisticas#clinica", as: "clinica_estatisticas"
    get "/acompanhamentos", to: "estatisticas#acompanhamentos", as: "acompanhamentos_estatisticas"
    get "/atendimentos", to: "estatisticas#atendimentos", as: "atendimentos_estatisticas"
    get "/profissionais", to: "estatisticas#profissionais", as: "profissionais_estatisticas"
    get "/pacientes", to: "estatisticas#pacientes", as: "pacientes_estatisticas"
    get "/instrumentos", to: "estatisticas#instrumentos", as: "instrumentos_estatisticas"
    get "/financeiro", to: "estatisticas#financeiro", as: "financeiro_estatisticas"
  end

  resources :adulto_anamneses

  get 'clinica/index'

  resources :biblioteca_obras
  resources :acompanhamento_finalizacao_motivos
  resources :acompanhamento_reajuste_motivos
  resources :acompanhamneto_finalizacao_motivos
  resources :atendimento_tipos
  resources :profissional_funcoes
  resources :civil_estados
  resources :atendimento_plataformas
  resources :atendimento_modalidades
  resources :atendimento_local_tipos
  resources :acompanhamento_tipos

  get 'financeiro/index'
  get 'financeiro/atendimento_valor'
  get 'financeiro/recebimento_pessoa'
  get 'financeiro/repasse_profissionais'

  # usuarios do sistema e sessão
  resources :usuarios
  resources :sessoes
  get 'criar_usuario', to: "usuarios#new", as: 'criar_usuario'
  get 'entrar', to: "sessoes#new", as: 'entrar'
  get 'sair', to: "sessoes#destroy", as: 'sair'

  # instrumentos
  resources :instrumentos
  resources :instrumento_relatos

  # biblioteca
  scope :biblioteca do
    resources :biblioteca_autores, path: '/autores'
    get '/', to: "biblioteca#index", as: 'biblioteca'
    resources :biblioteca_obras, path: '/obras'
    resources :biblioteca_tags, path: '/tags'
    resources :biblioteca_periodicos, path: '/periodicos'
    resources :biblioteca_editoras, path: '/editoras'
  end
  #resources :biblioteca_obras
  #resources :biblioteca_autores
  #resources :biblioteca_tags
  
  scope :financeiro do
    resources :atendimento_valores
    resources :recebimentos do
      collection do
        get 'inline-new', to: :inline_new
        get 'inline-adicionar', to: :inline_adicionar
        get 'select-acompanhamento', to: :select_acompanhamento
        get 'cobranca_pendente', to: :cobranca_pendente
      end
    end
    resources :profissional_financeiro_repasses, path: '/repasses'
    resources :acompanhamento_reajustes do
      member do
        post :aplicar_ajuste
      end
    end
  end

  scope :clinica do
    get '/', to: "clinica#index", as: 'clinica'

    resources :profissionais do
      member do
        get :acompanhamentos
        get :contrato_modelos
        get :novo_contrato_modelo
        get :agenda
        get :financeiro
        get :atendimento_valores
        get :financeiro_repasses
        get :recebimentos
        scope :folgas do
          get "/", as: :folgas, action: :folgas
          get "/new", as: :new_folga, action: :new_folga
          get "/edit/:profissional_folga_id", as: :edit_folga, action: :edit_folga
          delete ":profissional_folga_id", as: :destroy_folga, action: :destroy_folga
        end
      end
    end

    resources :profissional_horarios

    resources :atendimento_locais do
      member do
        get :atendimentos
      end
    end

    resources :profissional_folgas
  end

  # Documentos
  scope :documentos do
    get '/', to: "documentos#index", as: :documentos
    # anamneses
    resources :infantojuvenil_anamneses
    # devolutivas
    resources :pessoa_devolutivas, path: '/devolutivas', as: "devolutivas"
    resources :pessoa_devolutivas
    # laudos
    resources :laudos do
      member do
        # ajax much
        patch :identificacao_update
        patch :informacoes_update
        get :data_final
        get :data_final_edit

        get :finalidade
        get :finalidade_edit

        get :interessado
        get :interessado_edit

        get :demanda
        get :demanda_edit

        get :tecnicas
        get :tecnicas_edit

        get :analise
        get :analise_edit

        get :conclusao
        get :conclusao_edit

        get :referencias
        get :referencias_edit
      end
    end
    # modelos de contrato
    resources :profissional_contrato_modelos, path: :contratos

    get :gerar, to: "documentos#gerar", as: :gerar_documento
  end

  resources :crp_regioes
  resources :profissional_notas
  #resources :pessoas
  resources :pessoas, path: '/cadastros' do
    member do
      get :devolutivas, path: 'devolutivas'
      get :responsavel_devolutivas
      get :show_parentescos, path: "parentescos"
      get :new_parentesco
      post :create_parentesco
      get :edit_parentesco, path: "parentescos/:parente_id"
      patch :update_parentesco, path: "parentescos/:parente_id/update"
      delete :destroy_parentesco, path: "parentescos/:parente_id/destroy"
      scope :recebimentos do
        get "/", to: "pessoas#recebimentos", as: "recebimentos"
        get 'new', to: "pessoas#new_recebimento", as: "new_recebimento"
        post :recebimentos, to: "pessoas#create_recebimento"
      end
      get :atendimento_valores
      get :financeiro
      get :prontuario
      get :acompanhamento_reajustes
      scope :acompanhamentos do
        get "/", to: "pessoas#acompanhamentos", as: "acompanhamentos"
        get 'new', to: "pessoas#new_acompanhamento", as: "new_acompanhamento"
        post :acompanhamentos, to: "pessoas#create_acompanhamento"
      end
      get :show_medicacoes, path: "medicacao"
      get :new_medicacao
      post :create_medicacao
      get :edit_medicacao, path: "medicacao/:med_id/edit"
      patch :update_medicacao, path: "medicacao/:med_id/edit"
      delete :destroy_medicacao, path: "medicacao/:med_id/destroy"

      get :instrumentos
      get :instrumento_relato, path: "instrumento_relato/:instrumento_relato_id"
    end
  end
  resources :paises
  resources :continentes

  resources :acompanhamentos do
    get 'em-andamento', on: :collection, action: :index, em_andamento: true

    member do
      post :new_atendimento_proxima_semana, path: 'novo_atendimento_proxima_semana'
      get :declaracao
      get :declaracao_detalhada
      get :prontuario
      get :contrato
      get :financeiro
      get :acompanhamento_reajustes do
      end
      get :atendimento_valores
      get :new_atendimento
      get :recebimentos
      get :new_recebimento
      get :declaracao_ir
      get :declaracao_finalizacao

      get :instrumentos
      get :instrumento_relato, path: "instrumento_relatos/:instrumento_relato_id"
    end
  end

  resources :atendimentos do
    member do
      post :reagendar_para_proxima_semana
      get :reagendar_para_proxima_semana
      post :create_atendimento_valor
      post :gerar_atendimento_valor
      get :declaracao_comparecimento
      get :modelo_relato

      # elementos secundários
      get :instrumentos_usados
      post :instrumento_relato
      get :new_instrumento_relato
      post :create_instrumento_relato

      # partials (ajax)
      get :anotacoes
      get :anotacoes_edit
      patch :anotacoes_update

      get :data
      get :data_edit
      patch :data_update

      get :horario
      get :horario_edit
      patch :horario_update

      get :status
      get :status_edit
      patch :status_update
    end
  end

  # horarios de atendimentos
  get '/agenda/fixa', to: "acompanhamento_horarios#index"
  get '/agenda/fixa/new', to: "acompanhamento_horarios#new", as: "new_acompanhamento_horario"
  get '/agenda/fixa/voltar/:id', to: "acompanhamento_horarios#show_botao_novo_horario", as: "show_botao_novo_horario_acompanhamento_horario"
  post '/agenda/fixa/:id', to: "acompanhamento_horarios#create", as: "acompanhamento_horarios"
  delete 'agenda/fixa/destruir/:id', to: "acompanhamento_horarios#destroy", as: "acompanhamento_horario"

  resources :profissional_documento_modelos

  root to: "application#index"
  get '/configurar', to: "application#configurar"
  post "/primeira_pessoa_cadastro", to: "application#registrar_pessoa"
  post "/primeiro_profissional_cadastro", to: "application#registrar_profissional"
  post "/primeiro_usuario_cadastro", to: "application#registrar_usuario"

  get '/ajuda', to: "application#ajuda"
  get '/financeiro', to: "financeiro#index"

  namespace :admin do
    root to: "admin#index"
    post "/update", to: "admin#update"
    get "/new", to: "admin#new"
    post "/create", to: "admin#create"
    ActiveRecord::Base.connection.tables.each do |t|
      resources t.to_sym
    end
    delete "/destroy", to: "admin#destroy"
    # AdminController.paths.each do |m|
    #   resources m.to_sym
      #get m.to_sym, to: "admin##{m}", as: m.to_s
    # end
  end

  # rotas de parciais
  # application
  get '/update_tabela_atendimentos_hoje', to: "application#update_tabela_atendimentos_hoje"
  get '/update_calendario_atendimentos_semana', to: "application#update_calendario_atendimentos_semana"
  post '/update_calendario_atendimentos_semana', to: "application#update_calendario_atendimentos_semana"


  # rotas pdf
  get "/acompanhamentos/:id/detalhes", to: "acompanhamentos#caso_detalhes"

  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
