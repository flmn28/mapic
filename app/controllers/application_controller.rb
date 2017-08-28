class ApplicationController < ActionController::Base
  include UsersHelper

  protect_from_forgery with: :exception

  private
    def authenticated_user
      unless session[:user_id]
        flash[:notice] = "ログインしてください"
        redirect_to login_path
      end
    end
end
