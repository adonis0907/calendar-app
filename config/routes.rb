Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "calendar#index"

  get "/reminder/:month/:day/:year", to: "calendar#show"
  get "/reminder/:month/:day/:year/new", to: "calendar#new"
  get "/reminder/:id/edit", to: "calendar#edit"
  post "/reminder", to: "calendar#save"
  patch "/reminder/:id", to: "calendar#update"
  delete "/reminder/:id", to: "calendar#destroy"
end
