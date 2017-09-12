require 'rails_helper'

RSpec.describe Location, type: :model do

  let(:image_path) { File.join(Rails.root, 'spec/support/images/image1.jpg') }
  let(:image) { Rack::Test::UploadedFile.new(image_path) }

  describe "validation" do
    before do
      @user = create :user, id: 1
    end

    context "with all form fullfilled correctly" do
      before do
        @location = Location.new(title: "title1", comment: "comment1", address: "address1",
                                 latitude: 36, longitude: 137, user_id: 1, image: image)
      end
      it "is valid" do
        expect(@location).to be_valid
      end
    end

    column_names = [:title, :comment, :address, :latitude, :longitude, :user_id]
    column_names.each do |column_name|
      context "with no #{column_name} data" do
        before do
          @location = Location.new(title: "title1", comment: "comment1", address: "address1",
                                   latitude: 36, longitude: 137, user_id: 1)
          @location[column_name] = ""
        end
        it "is invalid" do
          expect(@location).not_to be_valid
        end
      end
    end

    context "when title is too long" do
      before do
        @location = Location.new(title: "a" * 51, comment: "comment1", address: "address1",
                                 latitude: 36, longitude: 137, user_id: 1)
      end
      it "is invalid" do
        expect(@location).not_to be_valid
      end
    end

    context "when comment is too long" do
      before do
        @location = Location.new(title: "title1", comment: "a" * 256, address: "address1",
                                 latitude: 36, longitude: 137, user_id: 1)
      end
      it "is invalid" do
        expect(@location).not_to be_valid
      end
    end
  end

  describe "association" do
    before do
      @user1 = create :user, id: 1
      @user2 = create :user, id: 2, email: "user2@sample.com"
      @user3 = create :user, id: 3, email: "user3@sample.com"
      @location = create :location, id: 1
      @tag1 = create :tag, id: 1
      @tag2 = create :tag, id: 2, name: "tag2"
      @tag3 = create :tag, id: 3, name: "tag3"
      create :locations_tag, id: 1, location_id: 1, tag_id: 1
      create :locations_tag, id: 2, location_id: 1, tag_id: 3
      create :like, id: 1, user_id: 1, location_id: 1
      create :like, id: 2, user_id: 3, location_id: 1
    end

    it "belongs to a user" do
      expect(@location.user).to eq @user1
    end

    it "has correct tags" do
      expect(@location.tags.count).to eq 2
      expect(@location.tags.first).to eq @tag1
      expect(@location.tags.last).to eq @tag3
    end

    it "has correct liking_users" do
      expect(@location.liking_users.count).to eq 2
      expect(@location.liking_users.first).to eq @user1
      expect(@location.liking_users.last).to eq @user3
    end
  end
end
