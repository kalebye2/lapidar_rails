Rails.application.routes.draw do
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

  # anamneses
  resources :infantojuvenil_anamneses

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
      end
    end
    resources :profissional_financeiro_repasses, path: '/repasses'
  end

  resources :profissionais do
    member do
      get :acompanhamentos
    end
  end
  resources :pessoa_devolutivas, path: '/devolutivas', as: "devolutivas"
  resources :pessoa_devolutivas
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
      get :recebimentos
      get :financeiro
    end
  end
  resources :paises
  resources :continentes
  resources :acompanhamentos do
    post :new_atendimento_proxima_semana, path: 'novo_atendimento_proxima_semana'

    get 'em-andamento', on: :collection, action: :index, em_andamento: true

    member do
      get :declaracao
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

  get '/ajuda', to: "application#ajuda"
  get '/financeiro', to: "financeiro#index"

  scope :admin do
    get '/', to: "admin#index", as: 'admin'
    AdminController.paths.each do |m|
      resources m.to_sym
      #get m.to_sym, to: "admin##{m}", as: m.to_s
    end
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
