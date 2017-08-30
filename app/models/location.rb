class Location < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :comment, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  belongs_to :user
  has_many :locations_tags
  has_many :tags, through: :locations_tags
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
end
