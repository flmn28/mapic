require "rails_helper"

RSpec.describe MapController, type: :routing do
  describe "routing" do
    it "routes to #top by root_path" do
      expect(:get => root_path).to route_to("home#top")
    end

    it "routes to #top" do
      expect(:get => top_path).to route_to("home#top")
    end
  end
end
