class User < ApplicationRecord
  has_secure_password

  validates :name, presence: { message: "ユーザー名を入力してください" },
                   length: { maximum: 50, message: "ユーザー名は50文字以内で入力してください" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: { message: "メールアドレスを入力してください" },
                    length: { maximum: 255, message: "メールアドレスは255文字以内で入力してください" },
                    uniqueness: { case_sensitive: false, message: "メールアドレスは既に存在します" },
                    format: { with: VALID_EMAIL_REGEX, allow_blank: true, message: "メールアドレスを正しく入力してください" }
  VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/i
  validates :password, length: { minimum: 6, allow_blank: true, message: "パスワードは6文字以上で設定してください" },
                       format: { with: VALID_PASSWORD_REGEX, allow_blank: true, message: "パスワードには半角英数字を使用してください" }

  has_many :locations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_locations, through: :likes, source: :location
end
