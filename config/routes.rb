Rails.application.routes.draw do
  resources :orders do
    patch 'update_route', on: :member
  end
  resources :routes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  constraints format: :json do
    get '/matching_routes', to: 'routes#matching_routes'
  end
end
