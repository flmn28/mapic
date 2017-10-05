class HomeController < ApplicationController
  before_action :redirect_to_top_when_logged_in

  def top
  end

end
