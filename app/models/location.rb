class Location < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates :title, presence: true, length: { maximum: 50 }
  validates :comment, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :image, presence: true

  belongs_to :user
  has_many :locations_tags, dependent: :destroy
  has_many :tags, through: :locations_tags
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
end
