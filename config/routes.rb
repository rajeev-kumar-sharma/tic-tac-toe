Rails.application.routes.draw do
  resources :games
  resources :users
  resources :moves
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
