require 'rails_helper'

RSpec.describe LocationsController, type: :controller do


  let(:image_path) { File.join(Rails.root, 'spec/support/images/image1.jpg') }
  let(:image) { Rack::Test::UploadedFile.new(image_path) }

  let(:valid_attributes) {
    { title: "title1", comment: "comment1", address: "address1", latitude: 36.0, longitude: 137.0, image: image }
  }
  let(:invalid_attributes) {
    { title: "", comment: "comment1", address: "address1", latitude: 36.0, longitude: 137.0, image: image }
  }

  let(:valid_session) { { user_id: 1 } }


  before do
    @user1 = create :user, id: 1
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
    create :tag, id: 1
    create :tag, id: 2
    create :tag, id: 3
    create :locations_tag, id: 1, location_id: 1, tag_id: 1
    create :locations_tag, id: 2, location_id: 1, tag_id: 2
    create :locations_tag, id: 3, location_id: 2, tag_id: 1
    create :locations_tag, id: 4, location_id: 2, tag_id: 3
    create :locations_tag, id: 5, location_id: 3, tag_id: 2
    create :locations_tag, id: 6, location_id: 4, tag_id: 3
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
    it "has locations which ordered correctly" do
      get :ranking, params: {}, session: valid_session
      expect(assigns(:locations)).to eq [@location3, @location2, @location4, @location1]
    end
  end

  describe "POST #ranking_option" do
    it "can be ranked and selected by tag" do
      get :ranking_option, params: { tag1: true, tag2: true }, session: valid_session, xhr: true
      expect(assigns(:locations)).to eq [@location3, @location2, @location1]
    end
  end

  describe "GET #new" do
    context "when it is not redirected" do
      subject { get :new, params: {address: 'address', latitude: '35', longitude: '140'}, session: valid_session }

      it "returns a success response" do
        subject
        expect(response).to be_success
      end

      it "receive correct values from params beforehand" do
        subject
        expect(assigns(:location).address).to eq 'address'
        expect(assigns(:location).latitude).to eq 35
        expect(assigns(:location).longitude).to eq 140
      end
    end

    context "when it is redirected" do
      subject { get :new, params: {title: "title1", address: 'address', latitude: '35', longitude: '140', errors: ["error1", "error2"]}, session: valid_session }

      it "receive correct values of params from create" do
        subject
        expect(assigns(:location).title).to eq 'title1'
      end

      it "assigns correct error messages" do
        subject
        expect(assigns(:error_messages)).to eq ["error1", "error2"]
      end
    end
  end

  describe "GET #edit" do
    context "when it is not redirected" do
      subject { get :edit, params: {id: 1}, session: valid_session }

      it "returns a success response" do
        subject
        expect(response).to be_success
      end

      it "does not replace columns" do
        subject
        expect(assigns(:location)).to eq @location1
      end
    end

    context "when it is redirected" do
      subject { get :new, params: {title: "title2", errors: ["error1", "error2"]}, session: valid_session }

      it "replaces columns" do
        subject
        expect(assigns(:location).title).to eq "title2"
      end

      it "assigns correct error messages" do
        subject
        expect(assigns(:error_messages)).to eq ["error1", "error2"]
      end
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
        post :create, params: {location: valid_attributes, tag1: true, tag3: true}, session: valid_session
        expect(LocationsTag.count).to eq 8
        expect(LocationsTag.last.tag_id).to eq 3
      end

      it "set a success message to flash" do
        post :create, params: {location: valid_attributes}, session: valid_session
        expect(flash[:success]).to eq "投稿が完了しました"
      end

      it "redirects to root" do
        post :create, params: {location: valid_attributes}, session: valid_session
        expect(response).to redirect_to map_path
      end
    end

    context "with invalid params" do
      it "redirects to new" do
        post :create, params: {location: invalid_attributes}, session: valid_session
        expect(response).to redirect_to new_location_path(title: "",
                                                          comment: "comment1",
                                                          address: "address1",
                                                          latitude: 36.0,
                                                          longitude: 137.0,
                                                          errors: ["タイトルを入力してください"])
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "title2", comment: "comment2", image: image }
      }

      it "updates the requested location" do
        put :update, params: {id: @location1.to_param, location: new_attributes}, session: valid_session
        @location1.reload
        expect(@location1.title).to eq "title2"
      end

      it "update locations_tags" do
        put :update, params: {id: @location1.to_param, location: new_attributes, tag1: true, tag3: true }, session: valid_session
        expect(@location1.tags.count).to eq 2
        expect(@location1.tags.last.id).to eq 3
      end

      it "set a success message to flash" do
        put :update, params: {id: @location1.to_param, location: new_attributes}, session: valid_session
        expect(flash[:success]).to eq "投稿を編集しました"
      end

      it "redirects to the location" do
        put :update, params: {id: @location1.to_param, location: new_attributes}, session: valid_session
        expect(response).to redirect_to(@location1)
      end
    end

    context "with invalid params" do
      it "redirect to edit" do
        put :update, params: {id: 1, location: invalid_attributes}, session: valid_session
        expect(response).to redirect_to edit_location_path(title: "",
                                                           comment: "comment1",
                                                           errors: ["タイトルを入力してください"])
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
