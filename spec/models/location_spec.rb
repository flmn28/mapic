require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "validation" do
    before do
      @user = create :user, id: 1
    end

    context "with all form fullfilled correctly" do
      before do
        @location = Location.new(title: "title1", comment: "comment1", address: "address1",
                                 latitude: 36, longitude: 137, user_id: 1)
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
      @user = create :user, id: 1
      @location = create :location, id: 1
      @tag1 = create :tag, id: 1
      @tag2 = create :tag, id: 2, name: "tag2"
      @tag3 = create :tag, id: 3, name: "tag3"

      create :locations_tag, id: 1, location_id: 1, tag_id: 1
      create :locations_tag, id: 2, location_id: 1, tag_id: 2
    end

    it "belongs to a user" do
      expect(@location.user).to eq @user
    end

    it "has correct tags" do
      expect(@location.tags.count).to eq 2
    end
  end
end
