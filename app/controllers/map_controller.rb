class MapController < ApplicationController

  def index
    @locations = Location.all
  end

  def option
    params_array = Tag.all.map { |tag| params["tag" + tag.id.to_s] }
    @locations = Location.select_by_option(params[:myself], params[:like], params_array, current_user)
  end

end
