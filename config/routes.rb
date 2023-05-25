Rails.application.routes.draw do
  get 'atendimentos/index'
  get 'atendimentos/show'
  get 'atendimentos/new'
  get 'atendimentos/edit'
  get 'atendimentos/create'
  get 'atendimentos/update'
  get 'atendimentos/destroy'
  get 'acompanhamentos/index'
  get 'acompanhamentos/show'
  get 'acompanhamentos/new'
  get 'acompanhamentos/edit'
  get 'acompanhamentos/create'
  get 'acompanhamentos/update'
  get 'acompanhamentos/destroy'
  get 'profissional/index'
  get 'profissional/show'
  get 'profissional/new'
  get 'profissional/edit'
  get 'profissional/create'
  get 'profissional/update'
  get 'profissional/destroy'
  resources :usuario_devolutivas
  resources :crp_regioes
  resources :profissional_notas
  resources :usuarios
  resources :pessoas
  resources :pessoas, path: '/cadastros'
  resources :paises
  resources :continentes
  resources :acompanhamentos
  root to: "application#index"
  scope :admin do
      end

  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"
  get "psicologos/pdf/:id", to: "psicologos#pdf"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
