Rails.application.routes.draw do
  root "docs#index"

  resources :docs, param: :slug
  get "/about", to: "homes#about"
end
