require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:valid_session) { { user_id: 1 } }

  before do
    @user = create :user, id: 1
    @location = create :location, id: 1
  end

  describe "POST #like" do
    it "create new like" do
      post :like, params: { location_id: @location.id }, session: valid_session, xhr: true
      expect(Like.all.count).to eq 1
      expect(Like.first.user_id).to eq 1
      expect(Like.first.location_id).to eq 1
    end

    it "set correct location" do
      post :like, params: { location_id: @location.id }, session: valid_session, xhr: true
      expect(assigns(:location)).to eq @location
    end
  end

  describe "DELETE #unlike" do
    it "destroy one like" do
      create :like, user_id: 1, location_id: 1
      delete :unlike, params: { location_id: @location.id }, session: valid_session, xhr: true
      expect(Like.all.count).to eq 0
    end

    it "set correct location" do
      create :like, user_id: 1, location_id: 1
      delete :unlike, params: { location_id: @location.id }, session: valid_session, xhr: true
      expect(assigns(:location)).to eq @location
    end
  end
end
