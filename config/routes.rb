Rails.application.routes.draw do

  get 'map/index'

  resources :users, except: :new
  get '/signup' => 'users#new'
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  post '/logout' => 'users#logout'

  root 'map#index'

end
