require 'rails_helper'

RSpec.describe "locations/index", type: :view do
  before(:each) do
    assign(:locations, [
      Location.create!(
        :title => "Title",
        :comment => "MyText",
        :address => "Address",
        :latitude => 2.5,
        :longitude => 3.5,
        :user_id => 4
      ),
      Location.create!(
        :title => "Title",
        :comment => "MyText",
        :address => "Address",
        :latitude => 2.5,
        :longitude => 3.5,
        :user_id => 4
      )
    ])
  end

  it "renders a list of locations" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
