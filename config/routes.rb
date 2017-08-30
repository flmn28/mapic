Rails.application.routes.draw do

  root 'map#index'

  resources :users, except: :new
  get '/signup' => 'users#new'
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  post '/logout' => 'users#logout'

  resources :locations

  post '/like/:location_id' => 'likes#like', as: 'like'
  delete 'unlike/:location_id' => 'likes#unlike', as: 'unlike'

end
