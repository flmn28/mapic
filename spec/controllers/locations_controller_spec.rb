require 'rails_helper'

RSpec.describe LocationsController, type: :controller do


  let(:image_path) { File.join(Rails.root, 'spec/support/images/image1.jpg') }
  let(:image) { Rack::Test::UploadedFile.new(image_path) }

  let(:valid_attributes) {
    { title: "title1", comment: "comment1", address: "address1", latitude: 36, longitude: 137, image: image }
  }
  let(:invalid_attributes) {
    { title: "", comment: "comment1", address: "address1", latitude: 36, longitude: 137, image: image }
  }

  let(:valid_session) { { user_id: 1 } }


  before do
    @user = create :user, id: 1
  end

  describe "GET #index" do
    xit "returns a success response" do
      location = Location.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    xit "returns a success response" do
      location = Location.create! valid_attributes
      get :show, params: {id: location.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #ranking" do
    before do
      @user2 = create :user, id: 2, email: "user2@sample.com"
      @location1 = create :location, id: 1
      @location2 = create :location, id: 2
      @location3 = create :location, id: 3
      @location4 = create :location, id: 4
      create :like, id: 1, user_id: 2, location_id: 1
      create :like, id: 2, user_id: 2, location_id: 2
      create :like, id: 3, user_id: 2, location_id: 2
      create :like, id: 4, user_id: 2, location_id: 2
      create :like, id: 5, user_id: 2, location_id: 3
      create :like, id: 6, user_id: 2, location_id: 3
      create :like, id: 7, user_id: 2, location_id: 3
      create :like, id: 8, user_id: 2, location_id: 3
      create :like, id: 9, user_id: 2, location_id: 4
      create :like, id: 10, user_id: 2, location_id: 4
    end

    it "has locations which ordered correctly" do
      get :ranking, params: {}, session: valid_session
      expect(assigns(:locations)).to eq [@location3, @location2, @location4, @location1]
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end

    it "receive correct values from params beforehand" do
      get :new, params: {address: 'address', latitude: '35', longitude: '140'}, session: valid_session
      expect(assigns(:location).address).to eq 'address'
      expect(assigns(:location).latitude).to eq 35
      expect(assigns(:location).longitude).to eq 140
    end
  end

  describe "GET #edit" do
    xit "returns a success response" do
      location = Location.create! valid_attributes
      get :edit, params: {id: location.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Location" do
        expect {
          post :create, params: {location: valid_attributes}, session: valid_session
        }.to change(Location, :count).by(1)
      end

      it "has a current_user.id as user_id" do
        post :create, params: {location: valid_attributes}, session: valid_session
        expect(assigns(:location).user_id).to eq 1
      end

      it "create correct locations_tags" do
        create :tag, id: 1
        create :tag, id: 2
        create :tag, id: 3
        post :create, params: {location: valid_attributes, scenery: true, nature: true}, session: valid_session
        expect(LocationsTag.count).to eq 2
        expect(LocationsTag.first.tag_id).to eq 1
        expect(LocationsTag.last.tag_id).to eq 3
      end

      it "redirects to root" do
        post :create, params: {location: valid_attributes}, session: valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {location: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      xit "updates the requested location" do
        location = Location.create! valid_attributes
        put :update, params: {id: location.to_param, location: new_attributes}, session: valid_session
        location.reload
        skip("Add assertions for updated state")
      end

      xit "redirects to the location" do
        location = Location.create! valid_attributes
        put :update, params: {id: location.to_param, location: valid_attributes}, session: valid_session
        expect(response).to redirect_to(location)
      end
    end

    context "with invalid params" do
      xit "returns a success response (i.e. to display the 'edit' template)" do
        location = Location.create! valid_attributes
        put :update, params: {id: location.to_param, location: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    xit "destroys the requested location" do
      location = Location.create! valid_attributes
      expect {
        delete :destroy, params: {id: location.to_param}, session: valid_session
      }.to change(Location, :count).by(-1)
    end

    xit "redirects to the locations list" do
      location = Location.create! valid_attributes
      delete :destroy, params: {id: location.to_param}, session: valid_session
      expect(response).to redirect_to(locations_url)
    end
  end

end
