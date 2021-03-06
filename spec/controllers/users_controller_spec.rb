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
      @user1 = create :user, id: 1
      create :user, id: 2, email: "user2@sample.com"
      @location1 = create :location, id: 1, created_at: DateTime.current - 2
      @location2 = create :location, id: 2, user_id: 2, created_at: DateTime.current - 1
      @location3 = create :location, id: 3, created_at: DateTime.current
    end

    it "has locations of current_user" do
      get :mypage, params: {}, session: valid_session
      expect(assigns(:locations).count).to eq 2
      expect(assigns(:locations).first).to eq @location3
      expect(assigns(:locations).last).to eq @location1
    end

    it "has a correct title" do
      get :mypage, params: {}, session: valid_session
      expect(assigns(:title)).to eq "#{@user1.name}さんの投稿"
    end
  end

  describe "POST #mypage_option" do
    before do
      @user1 = create :user, id: 1
      create :user, id: 2, email: "user2@sample.com"
      @location1 = create :location, id: 1, user_id: 1, created_at: DateTime.current - 5
      @location2 = create :location, id: 2, user_id: 1, created_at: DateTime.current - 4
      @location3 = create :location, id: 3, user_id: 1, created_at: DateTime.current - 3
      @location4 = create :location, id: 4, user_id: 2, created_at: DateTime.current - 2
      @location5 = create :location, id: 5, user_id: 2, created_at: DateTime.current - 1
      @location6 = create :location, id: 6, user_id: 2, created_at: DateTime.current
      @tag1 = create :tag, id: 1
      @tag2 = create :tag, id: 2
      create :locations_tag, id: 1, location_id: 1, tag_id: 1
      create :locations_tag, id: 2, location_id: 2, tag_id: 2
      create :locations_tag, id: 3, location_id: 3, tag_id: 1
      create :locations_tag, id: 4, location_id: 4, tag_id: 2
      create :locations_tag, id: 5, location_id: 5, tag_id: 2
      create :locations_tag, id: 6, location_id: 6, tag_id: 1
      create :like, id: 1, user_id: 1, location_id: 5
      create :like, id: 2, user_id: 1, location_id: 6
    end

    it "can select my locations" do
      post :mypage_option, params: { condition: 1 }, session: valid_session, xhr: true
      expect(assigns(:locations).count).to eq 3
      expect(assigns(:locations).first).to eq @location3
      expect(assigns(:locations).last).to eq @location1
    end

    it "can select liking locations" do
      post :mypage_option, params: { condition: 2 }, session: valid_session, xhr: true
      expect(assigns(:locations).count).to eq 2
      expect(assigns(:locations).first).to eq @location6
      expect(assigns(:locations).last).to eq @location5
    end

    it "can select my tagged locations" do
      post :mypage_option, params: { condition: 1, tag1: true }, session: valid_session, xhr: true
      expect(assigns(:locations).count).to eq 2
      expect(assigns(:locations).first).to eq @location3
      expect(assigns(:locations).last).to eq @location1
    end

    it "can select liking tagged locations" do
      post :mypage_option, params: { condition: 2, tag2: true }, session: valid_session, xhr: true
      expect(assigns(:locations)).to eq [@location5]
    end

    it "has a corrrect title of my locations" do
      post :mypage_option, params: { condition: 1 }, session: valid_session, xhr: true
      expect(assigns(:title)).to eq "#{@user1.name}さんの投稿"
    end

    it "has a corrrect title of my locations" do
      post :mypage_option, params: { condition: 2, scenery: true }, session: valid_session, xhr: true
      expect(assigns(:title)).to eq "いいねした投稿"
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
      it "redirects to map" do
        get :new, params: {}, session: valid_session
        expect(response).to redirect_to(map_path)
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

      it "set a correct user_id to session" do
        post :create, params: {user: valid_attributes}
        expect(session[:user_id]).to eq User.last.id
      end

      it "set a success message to flash" do
        post :create, params: {user: valid_attributes}
        expect(flash[:success]).to eq "アカウントを作成しました"
      end

      it "redirects to map" do
        post :create, params: {user: valid_attributes}
        expect(response).to redirect_to map_path
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {user: invalid_attributes}
        expect(response).to be_success
      end
    end

    context "when password is blank" do
      it "modify error message" do
        post :create, params: { user: { name: "user1", email: "user1@sample.com", password: "", password_confirmation: "" } }
        expect(assigns(:user).errors.messages[:password]).to eq ["パスワードを入力してください"]
      end
    end

    context "when password_confirmation doesn't match password" do
      it "modify error message" do
        post :create, params: { user: { name: "user1", email: "user1@sample.com", password: "password1", password_confirmation: "password2" } }
        expect(assigns(:user).errors.messages[:password_confirmation]).to eq []
        expect(assigns(:user).errors.messages[:password]).to eq ["パスワードが一致していません"]
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

      it "set a success message to flash" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: new_attributes}, session: valid_session
        expect(flash[:success]).to eq "アカウントを編集しました"
      end

      it "redirects to mypage" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: new_attributes}, session: valid_session
        expect(response).to redirect_to mypage_path
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end

    context "when password_confirmation doesn't match password" do
      it "modify error message" do
        user = User.create! valid_attributes
        put :update, params: {id: user.to_param, user: { name: "user2", email: "user1@sample.com", password: "password1", password_confirmation: "password2" } }, session: valid_session
        expect(assigns(:user).errors.messages[:password_confirmation]).to eq []
        expect(assigns(:user).errors.messages[:password]).to eq ["パスワードが一致していません"]
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
      it "redirects to map" do
        get :login_form, params: {}, session: valid_session
        expect(response).to redirect_to(map_path)
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

      it "set a success message to flash" do
        expect(flash[:success]).to eq "ログインに成功しました"
      end

      it "redirects to map" do
        expect(response).to redirect_to(map_path)
      end
    end

    context "with invalid params" do
      before do
        post :login, params: { email: "user1@sample.com", password: "password2" }
      end

      it "can't set a user_id to session" do
        expect(session[:user_id]).to eq nil
      end

      it "set a error message to flash" do
        expect(flash[:danger]).to eq "メールアドレスまたはパスワードが間違っています"
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

    it "set a warning message to flash" do
      expect(flash[:warning]).to eq "ログアウトしました"
    end

    it "redirects to login form" do
      expect(response).to redirect_to(login_path)
    end
  end

# root_pathが変わったらテストも変える
  describe "authentication" do
    context "when user is not logged in" do
      it "redirect to root when access to top page" do
        get :index, params: {}
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is logged in" do
      it "redirect to map when access to login page" do
        get :login_form, params: {}, session: valid_session
        expect(response).to redirect_to(map_path)
      end
    end
  end

end
