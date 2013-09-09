require 'spec_helper'

describe GStaticMap::Image do
  it 'should have an url' do
    image = GStaticMap::Image.new(center: "Russia, Moscow")
    image.direct_url.should eq('http://maps.google.com/maps/api/staticmap?size=500x500&center=Russia%2C+Moscow&sensor=true&maptype=road&format=jpg&scale=1&key=&language=ru')
  end

  #TODO: add more specs
end