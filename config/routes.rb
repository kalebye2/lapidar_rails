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
  resources :biblioteca_obras
  resources :biblioteca_autores
  resources :biblioteca_tags
  
  scope :financeiro do
    resources :atendimento_valores
    resources :recebimentos
  end

  resources :profissionais do
    member do
      get :acompanhamentos
    end
  end
  resources :pessoa_devolutivas
  resources :laudos
  resources :crp_regioes
  resources :profissional_notas
  #resources :pessoas
  resources :pessoas, path: '/cadastros' do
    member do
      get :devolutivas, path: 'devolutivas'
      get :responsavel_devolutivas
    end
  end
  resources :paises
  resources :continentes
  resources :acompanhamentos do
    post :new_atendimento_proxima_semana, path: 'novo_atendimento_proxima_semana'
  end
  resources :atendimentos do
    member do
      post :reagendar_para_proxima_semana
      get :reagendar_para_proxima_semana
      post :create_atendimento_valor
    end
  end

  resources :profissional_documento_modelos

  root to: "application#index"
  get '/financeiro', to: "financeiro#index"

  scope :admin do
    get '/', to: "admin#index", as: 'admin'
    AdminController.paths.each do |m|
      resources m.to_sym
      #get m.to_sym, to: "admin##{m}", as: m.to_s
    end
  end

  # rotas pdf
  get "/acompanhamentos/:id/detalhes", to: "acompanhamentos#caso_detalhes"

  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
