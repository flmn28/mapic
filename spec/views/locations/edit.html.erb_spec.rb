require 'rails_helper'

RSpec.describe "locations/edit", type: :view do
  before(:each) do
    @location = assign(:location, Location.create!(
      :title => "MyString",
      :comment => "MyText",
      :address => "MyString",
      :latitude => 1.5,
      :longitude => 1.5,
      :user_id => 1
    ))
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do

      assert_select "input#location_title[name=?]", "location[title]"

      assert_select "textarea#location_comment[name=?]", "location[comment]"

      assert_select "input#location_address[name=?]", "location[address]"

      assert_select "input#location_latitude[name=?]", "location[latitude]"

      assert_select "input#location_longitude[name=?]", "location[longitude]"

      assert_select "input#location_user_id[name=?]", "location[user_id]"
    end
  end
end
