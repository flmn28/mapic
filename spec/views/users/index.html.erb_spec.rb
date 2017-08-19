require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
      :name => "user1",
      :email => "user1@sample.com",
      :password => "password1"
      ),
      User.create!(
      :name => "user2",
      :email => "user2@sample.com",
      :password => "password2"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "user1".to_s, :count => 1
    assert_select "tr>td", :text => "user2".to_s, :count => 1
    assert_select "tr>td", :text => "user1@sample.com".to_s, :count => 1
    assert_select "tr>td", :text => "user2@sample.com".to_s, :count => 1
  end
end
