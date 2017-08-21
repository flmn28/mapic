require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do

  before do
    user :create, { id: 1 }
  end

  describe "current_user" do
    context "when user is logged in" do
      xit "returns correct user instance" do
      end
    end

    context "when user is not logged in" do
      xit "has nil" do
      end
    end
  end

  describe "logged_in?" do
    context "when user is logged in" do
      xit "returns true" do
      end
    end

    context "when user is not logged in" do
      xit "returns false" do
      end
    end
  end

end
