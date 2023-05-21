Rails.application.routes.draw do
  resources :usuario_devolutivas
  resources :crp_regioes
  resources :profissional_notas
  resources :usuarios
  resources :pessoas
  resources :paises
  resources :continentes
  root to: "application#index"
  scope :admin do
      end

  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"
  get "psicologos/pdf/:id", to: "psicologos#pdf"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
