class Tag < ApplicationRecord
  has_many :locations_tags
  has_many :locations, through: :locations_tags
end
