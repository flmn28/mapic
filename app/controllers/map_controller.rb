class MapController < ApplicationController
  def index
    @params = [params[:scenery], params[:building], params[:nature],
               params[:food], params[:amusement], params[:others]]

    if !params[:myself] && !params[:like] && @params == Array.new(6)
      return @locations = Location.all
    end

    @location_ids_array = []

    if params[:myself]
      ids = current_user.locations.pluck(:id)
      @location_ids_array.concat(ids)
    end

    if params[:like]
      ids = current_user.like_locations.pluck(:id)
      @location_ids_array.concat(ids)
    end

    @params.each_with_index do |param, i|
      if param
        ids = Tag.find_by(id: i + 1).locations.pluck(:id)
        @location_ids_array.concat(ids)
      end
    end

    @location_ids = @location_ids_array.uniq

    @locations = []

    @location_ids.each do |id|
      location = Location.find_by(id: id)
      @locations << location
    end

    return @locations

  end
end
