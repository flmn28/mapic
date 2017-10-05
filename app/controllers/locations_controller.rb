class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
  end

  def show
  end

  def ranking
    location_ids = Like.group(:location_id).order('count_location_id DESC').limit(100).count(:location_id).keys
    @locations = location_ids.map { |id| Location.find_by(id: id) }
  end

  def ranking_option
    params_array = Tag.all.pluck(:id).map { |id| params["tag" + id.to_s] }

    ranked_location_ids = Like.group(:location_id).order('count_location_id DESC').limit(100).count(:location_id).keys

    if params_array == Array.new(params_array.count)
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
    @location = Location.new(title: params[:title],
                             comment: params[:comment],
                             address: params[:address],
                             latitude: params[:latitude],
                             longitude: params[:longitude])
    @error_messages = params[:errors]
  end

  def edit
    @location.assign_attributes(title: params[:title], comment: params[:comment]) if params[:errors]
    @error_messages = params[:errors]
  end

  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        create_locations_tags
        flash[:success] = "投稿が完了しました"
        format.html { redirect_to map_path }
        format.json { render :show, status: :created, location: @location }
      else
        modify_image_error_message
        format.html { redirect_to new_location_path(title: @location.title,
                                                    comment: @location.comment,
                                                    address: @location.address,
                                                    latitude: @location.latitude,
                                                    longitude: @location.longitude,
                                                    errors: @location.errors.messages.values.flatten) }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        @location.tags.destroy_all
        create_locations_tags
        flash[:success] = "投稿を編集しました"
        format.html { redirect_to @location }
        format.json { render :show, status: :ok, location: @location }
      else
        modify_image_error_message
        format.html { redirect_to edit_location_path(title: @location.title,
                                                     comment: @location.comment,
                                                     errors: @location.errors.messages.values.flatten) }
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

    def create_locations_tags
      Tag.all.each do |tag|
        LocationsTag.create(location_id: @location.id, tag_id: tag.id) if params["tag" + tag.id.to_s]
      end
    end

    def modify_image_error_message
      if @location.errors.messages[:image][0] == "translation missing: en.errors.messages.extension_whitelist_error"
        @location.errors.messages[:image] = ["ファイルの形式はjpg、jpeg、gif、pngのいずれかを使用してください"]
      end
    end
end
