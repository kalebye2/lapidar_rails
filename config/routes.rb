Rails.application.routes.draw do
  root to: "application#index"
  resources :profissional_funcoes
  resources :profissionals
  scope :admin do
    devise_for :psicologos
    devise_for :profissionals
  end

  resources :responsavel_usuarios
  resources :parentescos
  resources :psicologos
  resources :usuarios
  resources :crp_regiaos
  resources :municipios
  resources :civil_estados
  resources :instrucao_graus
  resources :ufs
  
  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"
  get "psicologos/pdf/:id", to: "psicologos#pdf"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
