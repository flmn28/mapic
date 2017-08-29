require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "association" do
    before do
      @user = create :user, id: 1
      @location1 = create :location, id: 1
      @location2 = create :location, id: 2
      @location2 = create :location, id: 3
      @tag = create :tag, id: 1
      create :locations_tag, id: 1, location_id: 1, tag_id: 1
      create :locations_tag, id: 2, location_id: 2, tag_id: 1
    end

    it "has correct locations" do
      expect(@tag.locations.count).to eq 2
    end
  end
end
