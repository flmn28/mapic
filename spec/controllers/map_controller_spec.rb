require 'rails_helper'

RSpec.describe MapController, type: :controller do
  let(:valid_session) { { user_id: 1 } }

  before do
    create :user, id: 1
    create :user, id: 2, email: "user2@sample.com"
    @location1 = create :location, id: 1, user_id: 1
    @location2 = create :location, id: 2, user_id: 1
    @location3 = create :location, id: 3, user_id: 2
    @location4 = create :location, id: 4, user_id: 2
    @location5 = create :location, id: 5, user_id: 2
    @tag1 = create :tag, id: 1
    @tag2 = create :tag, id: 2
    create :locations_tag, id: 1, location_id: 1, tag_id: 1
    create :locations_tag, id: 2, location_id: 2, tag_id: 2
    create :locations_tag, id: 3, location_id: 3, tag_id: 1
    create :locations_tag, id: 4, location_id: 4, tag_id: 2
    create :locations_tag, id: 5, location_id: 5, tag_id: 1
    create :like, id: 1, user_id: 1, location_id: 3
  end

  describe "GET #index" do
    it "returns http success" do
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(:success)
    end

    it "set @locations correct data" do
      get :index, params: {}, session: valid_session
      expect(assigns(:locations)).to eq [@location1, @location2, @location3, @location4, @location5]
    end

    it "can select myself" do
      get :index, params: { myself: true }, session: valid_session
      expect(assigns(:locations)).to eq [@location1, @location2]
    end

    it "can select like" do
      get :index, params: { like: true }, session: valid_session
      expect(assigns(:locations)).to eq [@location3]
    end

    it "can select tags" do
      get :index, params: { scenery: true }, session: valid_session
      expect(assigns(:locations)).to eq [@location1, @location3, @location5]
    end

    it "can select multiply" do
      get :index, params: { myself: true, like: true, scenery: true }, session: valid_session
      expect(assigns(:locations)).to eq [@location1, @location2, @location3, @location5]
    end
  end

end
