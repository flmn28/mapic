require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #top" do
    context "when user is not logged in" do
      it "returns http success" do
        get :top
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not logged in" do
      it "redirects to map" do
        get :top, session: { user_id: 1 }
        expect(response).to redirect_to map_path
      end
    end
  end

end
