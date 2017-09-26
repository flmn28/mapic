require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validation' do
    context "with all form fullfilled correctly" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password1")
      end

      it "is valid" do
        expect(@user).to be_valid
      end
    end

    context "with no name data" do
      before do
        @user = User.new(name: "", email: "user1@sample.com", password: "password1", password_confirmation: "password1")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:name]).to eq ["ユーザー名を入力してください"]
      end
    end

    context "with no email data" do
      before do
        @user = User.new(name: "user1", email: "", password: "password1", password_confirmation: "password1")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:email]).to eq ["メールアドレスを入力してください"]
      end
    end


    context "with no password data" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "", password_confirmation: "password1")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:password]).to eq ["can't be blank"]
      end
    end

    context "with no password_confirmation data" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:password_confirmation]).to eq ["doesn't match Password"]
      end
    end

    context "when password_confirmation has different value from password" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password2")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:password_confirmation]).to eq ["doesn't match Password"]
      end
    end

    context "when name is too long" do
      before do
        @user = User.new(name: "a" * 51, email: "user1@sample.com", password: "password1", password_confirmation: "password1")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:name]).to eq ["ユーザー名は50文字以内で入力してください"]
      end
    end

    context "when email is too long" do
      before do
        @user = User.new(name: "user1", email: "a" * 245 + "@sample.com", password: "password1", password_confirmation: "password1")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:email]).to eq ["メールアドレスは255文字以内で入力してください"]
      end
    end

    context "when email is already existed" do
      before do
        @user1 = User.create(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password1")
        @user2 = User.new(name: "user2", email: "user1@sample.com", password: "password2", password_confirmation: "password2")
      end

      it "is invalid" do
        expect(@user2).not_to be_valid
      end

      it "set a correct error message" do
        @user2.save
        expect(@user2.errors.messages[:email]).to eq ["メールアドレスは既に存在します"]
      end
    end

    context "when email has correct format" do
      valid_addresses = ["user@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org", "first.last@foo.jp", "alice+bob@baz.cn"]
      valid_addresses.each do |valid_address|
        user = User.new(name: "user1", email: valid_address, password: "password1", password_confirmation: "password1")
        it "is valid" do
          expect(user).to be_valid
        end
      end
    end

    context "when email has incorrect format" do
      invalid_addresses = ["user@example,com", "user_at_foo.org", "user.name@example.", "foo@bar_baz.com", "foo@bar+baz.com"]
      invalid_addresses.each do |invalid_address|
        user = User.new(name: "user1", email: invalid_address, password: "password1", password_confirmation: "password1")

        it "is invalid" do
          expect(user).not_to be_valid
        end

        it "set a correct error message" do
          user.save
          expect(user.errors.messages[:email]).to eq ["メールアドレスを正しく入力してください"]
        end
      end
    end

    context "when password is too shot" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "pass1", password_confirmation: "pass1")
      end

      it "is invalid" do
        expect(@user).not_to be_valid
      end

      it "set a correct error message" do
        @user.save
        expect(@user.errors.messages[:password]).to eq ["パスワードは6文字以上で設定してください"]
      end
    end

    context "when password has incorrect format" do
      invalid_passwords = ["pass word", "pass.word"]
      invalid_passwords.each do |invalid_password|
        user = User.new(name: "user1", email: "user1@sample.com", password: invalid_password, password_confirmation: invalid_password)

        it "is invalid" do
          expect(user).not_to be_valid
        end

        it "set a correct error message" do
          user.save
          expect(user.errors.messages[:password]).to eq ["パスワードには半角英数字を使用してください"]
        end
      end
    end
  end

  describe "association" do
    before do
      @user1 = create :user, id: 1
      @user2 = create :user, id: 2, email: "user2@sample.com"
      @location1 = create :location, id: 1, user_id: 1
      @location2 = create :location, id: 2, user_id: 1
      @location3 = create :location, id: 3, user_id: 2
      create :like, id: 1, user_id: 1, location_id: 1
      create :like, id: 2, user_id: 1, location_id: 3
    end

    it "has correct locations" do
      expect(@user1.locations).to eq [@location1, @location2]
    end

    it "has correct like_locations" do
      expect(@user1.like_locations.count).to eq 2
      expect(@user1.like_locations.first).to eq @location1
      expect(@user1.like_locations.last).to eq @location3
    end
  end
end
