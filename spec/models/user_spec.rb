require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe 'validation' do
    context "with all form fullfilled correctly" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password1")
      end
      it "is valid" do
        expect(@user).to be_valid
      end
    end

    column_names = [:name, :email]
    column_names.each do |column_name|
      context "with no #{column_name} data" do
        before do
          @user = User.new(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password1")
          @user[column_name] = ""
        end
        it "is invalid" do
          expect(@user).not_to be_valid
        end
      end
    end

    context "with no password data" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "", password_confirmation: "password1")
      end
      it "is invalid" do
        expect(@user).not_to be_valid
      end
    end

    context "with no password_confirmation data" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "")
      end
      it "is invalid" do
        expect(@user).not_to be_valid
      end
    end

    context "when password_confirmation has different value from password" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password2")
      end
      it "is invalid" do
        expect(@user).not_to be_valid
      end
    end

    context "when name is too long" do
      before do
        @user = User.new(name: "a" * 51, email: "user1@sample.com", password: "password1", password_confirmation: "password1")
      end
      it "is invalid" do
        expect(@user).not_to be_valid
      end
    end

    context "when email is too long" do
      before do
        @user = User.new(name: "user1", email: "a" * 245 + "@sample.com", password: "password1", password_confirmation: "password1")
      end
      it "is invalid" do
        expect(@user).not_to be_valid
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
    end

    context "when email has correct format" do
      invalid_addresses = ["user@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org", "first.last@foo.jp", "alice+bob@baz.cn"]
      invalid_addresses.each do |invalid_address|
        user = User.new(name: "user1", email: invalid_address, password: "password1", password_confirmation: "password1")
        it "is invalid" do
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
      end
    end

    context "when password is too shot" do
      before do
        @user = User.new(name: "user1", email: "user1@sample.com", password: "pass1", password_confirmation: "pass1")
      end
      it "is invalid" do
        expect(@user).not_to be_valid
      end
    end

    context "when password has incorrect format" do
      invalid_passwords = ["pass word", "pass.word"]
      invalid_passwords.each do |invalid_password|
        user = User.new(name: "user1", email: "user1@sample.com", password: invalid_password, password_confirmation: invalid_password)
        it "is invalid" do
          expect(user).not_to be_valid
        end
      end
    end
  end
end
