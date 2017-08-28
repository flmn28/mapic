class Location < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :comment, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  belongs_to :user
end
