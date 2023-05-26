Rails.application.routes.draw do
  resources :recebimentos, path: '/financeiro'
  resources :profissionais
  resources :usuario_devolutivas
  resources :crp_regioes
  resources :profissional_notas
  resources :usuarios
  #resources :pessoas
  resources :pessoas, path: '/cadastros'
  resources :paises
  resources :continentes
  resources :acompanhamentos
  resources :atendimentos
  resources :relatos
  root to: "application#index"
  scope :admin do
      end

  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
