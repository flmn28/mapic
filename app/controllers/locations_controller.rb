class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
  end

  def show
  end

  def ranking
    location_ids = Like.group(:location_id).order('count_location_id DESC').limit(10).count(:location_id).keys
    @locations = location_ids.map { |id| Location.find_by(id: id) }
  end

  def ranking_option
    params_array = [params[:scenery], params[:building], params[:nature],
               params[:food], params[:amusement], params[:others]]

    ranked_location_ids = Like.group(:location_id).order('count_location_id DESC').limit(10).count(:location_id).keys

    if params_array == Array.new(6)
      return @locations = ranked_location_ids.map { |id| Location.find_by(id: id) }
    end

    tagged_location_ids_array = []
    params_array.each_with_index do |param, i|
      if param
        ids = Tag.find_by(id: i + 1).locations.pluck(:id)
        tagged_location_ids_array.concat(ids)
      end
    end
    tagged_location_ids = tagged_location_ids_array.uniq

    location_ids = ranked_location_ids & tagged_location_ids
    @locations = location_ids.map { |id| Location.find_by(id: id) }
  end

  def new
    @location = Location.new(address: params[:address],
                             latitude: params[:latitude],
                             longitude: params[:longitude])
  end

  def edit
  end

  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        set_tags
        format.html { redirect_to root_path, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:title, :comment, :address, :latitude, :longitude, :image).merge(user_id: current_user.id)
    end

    def set_tags
      if params[:scenery]
        LocationsTag.create(location_id: @location.id, tag_id: 1)
      end
      if params[:building]
        LocationsTag.create(location_id: @location.id, tag_id: 2)
      end
      if params[:nature]
        LocationsTag.create(location_id: @location.id, tag_id: 3)
      end
      if params[:food]
        LocationsTag.create(location_id: @location.id, tag_id: 4)
      end
      if params[:amusement]
        LocationsTag.create(location_id: @location.id, tag_id: 5)
      end
      if params[:others]
        LocationsTag.create(location_id: @location.id, tag_id: 6)
      end
    end
end
