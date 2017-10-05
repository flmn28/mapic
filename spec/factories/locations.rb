FactoryGirl.define do
  factory :location do
    title "location1"
    comment "comment1"
    address "address1"
    latitude 36.0
    longitude 137.0
    user_id 1
    image Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/images/image1.jpg'))
  end
end
