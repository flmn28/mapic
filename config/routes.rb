Rails.application.routes.draw do

  root 'map#index'
  post '/option' => 'map#option'

  resources :users, except: :new
  get '/signup' => 'users#new'
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  post '/logout' => 'users#logout'
  get '/mypage' => 'users#mypage'
  post '/mypage_option' => 'users#mypage_option'

  resources :locations
  get '/ranking' => 'locations#ranking'
  post '/ranking_option' => 'locations#ranking_option'

  post '/like/:location_id' => 'likes#like', as: 'like'
  delete '/unlike/:location_id' => 'likes#unlike', as: 'unlike'

end
