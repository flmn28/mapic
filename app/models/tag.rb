class Tag < ApplicationRecord
  has_many :locations_tags, dependent: :destroy
  has_many :locations, through: :locations_tags
end
