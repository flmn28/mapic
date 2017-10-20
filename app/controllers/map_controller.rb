class MapController < ApplicationController

  def index
    @locations = Location.all
  end

  def option
    params_array = Tag.all.map { |tag| params["tag" + tag.id.to_s] }
    return @locations = Location.all if !params[:myself] && !params[:like] && params_array == Array.new(params_array.count)

    selected_location_ids_array = []
    selected_location_ids_array.concat(current_user.locations.pluck(:id)) if params[:myself]
    selected_location_ids_array.concat(current_user.like_locations.pluck(:id)) if params[:like]
    selected_location_ids = selected_location_ids_array.uniq

    tagged_location_ids_array = []
    params_array.each_with_index do |param, i|
      tagged_location_ids_array.concat(Tag.find_by(id: i + 1).locations.pluck(:id)) if param
    end
    tagged_location_ids = tagged_location_ids_array.uniq

    location_ids = selected_location_ids.present? && tagged_location_ids.present? ? selected_location_ids & tagged_location_ids : selected_location_ids + tagged_location_ids
    @locations = location_ids.map { |id| Location.find_by(id: id) }
  end

end
