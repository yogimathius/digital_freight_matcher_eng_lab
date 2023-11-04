Rails.application.routes.draw do
  resources :routes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  Rails.application.routes.draw do
    get '/matching_routes', to: 'routes_controller#get_matching_routes'
  end
end
