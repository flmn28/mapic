require "rails_helper"

RSpec.describe LocationsController, type: :routing do
  describe "routing" do

    it "routes to #like" do
      expect(:post => "/like/1").to route_to("likes#like", :location_id => "1")
    end

    it "routes to #unlike" do
      expect(:delete => "/unlike/1").to route_to("likes#unlike", :location_id => "1")
    end

  end
end
