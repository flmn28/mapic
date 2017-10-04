class MapController < ApplicationController

  def index
    @locations = Location.all
  end

  def option
    params_array = Tag.all.pluck(:id).map { |id| params["tag" + id.to_s] }

    if !params[:myself] && !params[:like] && params_array == Array.new(params_array.count)
      return @locations = Location.all
    end

    selected_location_ids_array = []
    if params[:myself]
      ids = current_user.locations.pluck(:id)
      selected_location_ids_array.concat(ids)
    end
    if params[:like]
      ids = current_user.like_locations.pluck(:id)
      selected_location_ids_array.concat(ids)
    end
    selected_location_ids = selected_location_ids_array.uniq

    tagged_location_ids_array = []
    params_array.each_with_index do |param, i|
      if param
        ids = Tag.find_by(id: i + 1).locations.pluck(:id)
        tagged_location_ids_array.concat(ids)
      end
    end
    tagged_location_ids = tagged_location_ids_array.uniq

    if selected_location_ids.length > 0 && tagged_location_ids.length > 0
      location_ids = selected_location_ids & tagged_location_ids
    elsif selected_location_ids.length > 0
      location_ids = selected_location_ids
    elsif tagged_location_ids.length > 0
      location_ids = tagged_location_ids
    end

    @locations = []
    location_ids.each do |id|
      location = Location.find_by(id: id)
      @locations << location
    end
  end

end
