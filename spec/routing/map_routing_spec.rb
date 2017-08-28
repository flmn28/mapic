require "rails_helper"

RSpec.describe MapController, type: :routing do
  describe "routing" do

    it "routes to root" do
      expect(:get => root_path).to route_to("map#index")
    end

  end
end
