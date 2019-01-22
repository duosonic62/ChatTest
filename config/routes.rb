Rails.application.routes.draw do
  devise_for :users

  resources :rooms, only: %i[create]

  root  'rooms#index'
  get   'rooms/index'

  get   'rooms/new'
  post  'rooms/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
