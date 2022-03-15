Rails.application.routes.draw do
  
  post 'welcome', to: 'welcome#index'
  root to: 'welcome#index'

  resources :users
  resources :invites
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
