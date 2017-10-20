class Location < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates :title, presence: { message: "タイトルを入力してください" },
                    length: { maximum: 50, message: "タイトルは50文字以内で入力してください" }
  validates :image, presence: { message: "画像を選択してください" }
  validates :comment, presence: { message: "コメントを入力してください" },
                      length: { maximum: 255, message: "コメントは255文字以内で入力してください" }
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  belongs_to :user
  has_many :locations_tags, dependent: :destroy
  has_many :tags, through: :locations_tags
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  def self.select_by_option(myself_param, like_param, params_array, current_user)
    return self.all if !myself_param && !like_param && params_array == Array.new(params_array.count)

    my_locations_ids = myself_param ? current_user.locations.pluck(:id) : []
    like_location_ids = like_param ? current_user.like_locations.pluck(:id) : []
    selected_location_ids = (my_locations_ids + like_location_ids).uniq
    tagged_location_ids = self.return_tagged_location_ids(params_array)

    location_ids = selected_location_ids.present? && tagged_location_ids.present? ? selected_location_ids & tagged_location_ids : selected_location_ids + tagged_location_ids
    location_ids.map { |id| self.find_by(id: id) }
  end

  def self.select_by_ranking_option(params_array)
    ranked_location_ids = Like.group(:location_id).order('count_location_id DESC').limit(100).count(:location_id).keys
    return ranked_location_ids.map { |id| self.find_by(id: id) } if params_array == Array.new(params_array.count)

    tagged_location_ids = self.return_tagged_location_ids(params_array)

    location_ids = ranked_location_ids & tagged_location_ids
    location_ids.map { |id| self.find_by(id: id) }
  end

  def self.select_by_mypage_option(condition_param, params_array, current_user)
    return current_user.locations.order(created_at: :desc) if params_array == Array.new(params_array.count) && condition_param == "1"
    return current_user.like_locations.order(created_at: :desc) if params_array == Array.new(params_array.count) && condition_param == "2"

    selected_location_ids = condition_param == "1" ? current_user.locations.pluck(:id) : current_user.like_locations.pluck(:id)
    tagged_location_ids = self.return_tagged_location_ids(params_array)

    location_ids = selected_location_ids & tagged_location_ids
    unsorted_locations = location_ids.map { |id| self.find_by(id: id) }
    unsorted_locations.sort_by { |location| location.created_at }.reverse!
  end

  private

    def self.return_tagged_location_ids(params_array)
      tagged_location_ids_array = []
      params_array.each_with_index do |param, i|
        tagged_location_ids_array.concat(Tag.find_by(id: i + 1).locations.pluck(:id)) if param
      end
      tagged_location_ids_array.uniq
    end
end
