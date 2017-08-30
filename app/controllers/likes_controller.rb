class LikesController < ApplicationController

  def like
    @like = Like.new(user_id: current_user.id, location_id: params[:location_id])
    @like.save
    @location = Location.find_by(id: params[:location_id])
  end

  def unlike
    @like = Like.find_by(user_id: current_user.id, location_id: params[:location_id])
    @like.destroy
    @location = Location.find_by(id: params[:location_id])
  end

end
