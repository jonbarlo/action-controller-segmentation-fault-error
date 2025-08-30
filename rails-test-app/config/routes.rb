Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "test#index"
  
  # Test route for crash reproduction
  get "/test", to: "test#index"
end
