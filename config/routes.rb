Rails.application.routes.draw do
  resources :identities do
  	member do
  		get :uploade_data
  	end
    collection do
      get :country_select
    end
  end
  root 'home#index'
  get 'get_token' => 'home#get_token', as: :get_token
  
  post 'submit_uploade_data' => 'identities#submit_uploade_data', as: :submit_uploade_data
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
