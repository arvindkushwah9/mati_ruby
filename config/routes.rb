Rails.application.routes.draw do
  resources :identities
  root 'home#index'
  get 'get_token' => 'home#get_token', as: :get_token

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
