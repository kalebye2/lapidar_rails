Rails.application.routes.draw do
  root to: "application#index"
  scope :admin do
      end

  resources :crp_regiaos
  
  # get pdf
  get "/pdf_download", to: "application#pdf_download"
  get "/pdf_preview", to: "application#pdf_preview"
  get "psicologos/pdf/:id", to: "psicologos#pdf"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
