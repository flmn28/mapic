class ApplicationController < ActionController::Base
  include UsersHelper

  protect_from_forgery with: :exception

  private
    def authenticate_user
      unless session[:user_id]
        redirect_to root_path
      end
    end

    def redirect_to_top_when_logged_in
      if session[:user_id]
        flash[:danger] = "既にログインしています"
        redirect_to map_path
      end
    end
end
