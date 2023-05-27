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
  resources :usuario_extra_informacoes

  root to: "application#index"

  scope :admin do
  end

  # rotas pdf
  get "/acompanhamentos/:id/detalhes", to: "acompanhamentos#caso_detalhes"
  get "/relatos/:id/pdf", to: "relatos#show_pdf"
  get "/usuario_extra_informacoes/:id/pdf", to: "usuario_extra_informacoes#show_pdf"

  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
