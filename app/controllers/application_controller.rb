class ApplicationController < ActionController::Base
  include UsersHelper

  protect_from_forgery with: :exception

  private
    def authenticate_user
      unless session[:user_id]
        redirect_to root_path
      end
    end
end
