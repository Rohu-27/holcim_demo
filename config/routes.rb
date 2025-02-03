Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "login", to: "sessions#create"

  # Defines the root path route ("/")
  # root "posts#index"
  
  api_version(:module => "V1", :path => {:value => "api/v1"}) do
    resources :user
    resources :category
    resources :sub_category
    resources :complaint
    resources :album
  end

end
