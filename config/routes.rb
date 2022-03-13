Rails.application.routes.draw do
  
  get 'welcome', to: 'welcome#index'
  root to: 'welcome#index'

  get 'login', to: 'welcome#login'
  get 'logout', to: 'welcome#logout'
  post 'auth', to: 'welcome#auth'

  resources :users
  resources :invites
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
