Rails.application.routes.draw do
  root "homes#index"
  
  resources :docs, param: :slug
end
