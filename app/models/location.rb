class Location < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates :title, presence: { message: "を入力してください" },
                    length: { maximum: 50, message: "は50文字以内で入力してください" }
  validates :image, presence: { message: "を選択してください" }
  validates :comment, presence: { message: "を入力してください" },
                      length: { maximum: 255, message: "は255文字以内で入力してください" }
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  belongs_to :user
  has_many :locations_tags, dependent: :destroy
  has_many :tags, through: :locations_tags
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
end
