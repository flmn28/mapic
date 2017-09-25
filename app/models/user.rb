class User < ApplicationRecord
  has_secure_password

  validates :name, presence: { message: "を入力してください" },
                   length: { maximum: 50, message: "は50文字以内で入力してください" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: { message: "を入力してください" },
                    length: { maximum: 255, message: "は255文字以内で入力してください" },
                    uniqueness: { case_sensitive: false, message: "は既に存在します" },
                    format: { with: VALID_EMAIL_REGEX, allow_blank: true, message: "を正しく入力してください" }
  VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/i
  validates :password, length: { minimum: 6, allow_blank: true, message: "は6文字以上で設定してください" },
                       format: { with: VALID_PASSWORD_REGEX, allow_blank: true, message: "には半角英数字を使用してください" }

  has_many :locations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_locations, through: :likes, source: :location
end
