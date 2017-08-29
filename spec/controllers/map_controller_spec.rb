require 'rails_helper'

RSpec.describe MapController, type: :controller do

  before do
    create :user, id: 1
    @location1 = create :location, id: 1
    @location2 = create :location, id: 2, latitude: 37, longitude: 138
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "set @locations correct data" do
      get :index
      expect(assigns(:locations)).to eq [@location1, @location2]
    end
  end

end
