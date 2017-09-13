require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:valid_attributes) {
    { name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password1" }
  }

  let(:invalid_attributes) {
    { name: "", email: "user1@sample.com", password: "password1", password_confirmation: "password1" }
  }

  let(:valid_session) { { user_id: 1 } }

  describe "GET #index" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :show, params: {id: user.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #mypage" do
    before do
      create :user, id: 1
      create :user, id: 2, email: "user2@sample.com"
      @location1 = create :location, id: 1
      @location2 = create :location, id: 2, user_id: 2
      @location3 = create :location, id: 3
    end

    it "has locations of current_user" do
      get :mypage, params: {}, session: valid_session
      expect(assigns(:locations).count).to eq 2
      expect(assigns(:locations).first).to eq @location1
      expect(assigns(:locations).last).to eq @location3
    end
  end

  describe "GET #new" do
    context "when user is not logged in" do
      it "returns a success response" do
        get :new, params: {}
        expect(response).to be_success
      end
    end

    context "when user is logged in" do
      it "redirects to top page" do
        get :new, params: {}, session: valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :edit, params: {id: user.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: {user: valid_attributes}
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post :create, params: {user: valid_attributes}
        expect(response).to redirect_to(User.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {user: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: "user2", email: "user1@sample.com", password: "password1", password_confirmation: "password1"}
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: new_attributes}, session: valid_session
        user.reload
        expect(user.name).to eq "user2"
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: valid_attributes}, session: valid_session
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, params: {id: user.to_param}, session: valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      delete :destroy, params: {id: user.to_param}, session: valid_session
      expect(response).to redirect_to(users_url)
    end
  end

  describe "GET #login" do
    context "when user is not logged in" do
      it "returns a success response" do
        get :login_form, params: {}
        expect(response).to be_success
      end
    end

    context "when user is logged in" do
      it "redirects to top page" do
        get :login_form, params: {}, session: valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST #login" do
    before do
      @user = User.create! valid_attributes
    end

    context "with valid params" do
      before do
        post :login, params: { email: "user1@sample.com", password: "password1" }
      end

      it "set a correct user_id to session" do
        expect(session[:user_id]).to eq @user.id
      end

      it "redirects to top page" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid params" do
      before do
        post :login, params: { email: "user1@sample.com", password: "password2" }
      end

      it "can't set a user_id to session" do
        expect(session[:user_id]).to eq nil
      end

      it "render login_form" do
        expect(response).to render_template(:login_form)
      end
    end
  end

  describe "POST #logout" do
    before do
      post :logout, params: {}, session: valid_session
    end

    it "set nil to session[user_id]" do
      expect(session[:user_id]).to eq nil
    end

    it "redirects to login form" do
      expect(response).to redirect_to(login_path)
    end
  end

# root_pathが変わったらテストも変える
  describe "authentication" do
    context "when user is not logged in" do
      it "redirect to login when access to top page" do
        get :index, params: {}
        expect(response).to redirect_to(login_path)
      end
    end

    context "when user is logged in" do
      it "redirect to top when access to login page" do
        get :login_form, params: {}, session: valid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
