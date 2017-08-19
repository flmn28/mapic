Rails.application.routes.draw do

  resources :users, except: :new
  get '/signup' => 'users#new'
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  post '/logout' => 'users#logout'

end
