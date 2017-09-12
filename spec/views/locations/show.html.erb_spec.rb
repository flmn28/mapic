require 'rails_helper'

RSpec.describe "locations/show", type: :view do

  let(:image_path) { File.join(Rails.root, 'spec/support/images/image1.jpg') }
  let(:image) { Rack::Test::UploadedFile.new(image_path) }

  before(:each) do
    create :user, id: 4
    session[:user_id] = 4
    @location = assign(:location, Location.create!(
      :title => "Title",
      :comment => "MyText",
      :address => "Address",
      :latitude => 2.5,
      :longitude => 3.5,
      :user_id => 4,
      :image => image
    ))
  end

  xit "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/4/)
  end
end
