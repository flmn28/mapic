require "rails_helper"

RSpec.describe MapController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => map_path).to route_to("map#index")
    end

    it "routes to #option" do
      expect(:post => "/option").to route_to("map#option")
    end
  end
end
