Rails.application.routes.draw do
  get 'instrumentos/index'
  get 'instrumentos/new'
  get 'instrumentos/edit'
  get 'instrumento_relatos/index'
  get 'instrumento_relatos/new'
  get 'instrumento_relatos/edit'
  get 'financeiro/index'
  get 'financeiro/atendimento_valor'
  get 'financeiro/recebimento_pessoa'
  get 'financeiro/repasse_profissionais'

  resources :instrumento_relatos
  resources :infantojuvenil_anamneses
  resources :biblioteca_obras
  
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
      get :informacoes_extras
      get :informacao_extra_new, path: "informacoes_extras/new"
      get :informacao_extra_edit, path: "informacoes_extras/:extra_info_id"
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
    end
  end
  resources :relatos
  resources :pessoa_extra_informacoes

  resources :profissional_documento_modelos

  root to: "application#index"
  get '/financeiro', to: "financeiro#index"

  scope :admin do
  end

  # rotas pdf
  get "/acompanhamentos/:id/detalhes", to: "acompanhamentos#caso_detalhes"
  get "/relatos/:id/pdf", to: "relatos#show_pdf"
  get "/pessoa_extra_informacoes/:id/pdf", to: "pessoa_extra_informacoes#show_pdf"

  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
