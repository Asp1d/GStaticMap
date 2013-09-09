module GStaticMap
  class Marker
    require 'cgi'

    attr_accessor :color, :label, :latitude, :longitude, :location, :pin
    PIPE = CGI.escape('|')

    def initialize(options={})
      @color     = options[:color]          || nil
      @label     = options[:label]          || nil
      @latitude  = options[:latitude].to_s  || nil
      @longitude = options[:longitude].to_s || nil
      @location  = options[:location]       || nil
      @pin       = options[:pin]            || nil
    end

    def to_params
      str = []
      str << "icon:#{pin}"    if pin
      str << "color:#{color}" if color
      str << "label:#{label}" if label
      str << "#{location}"    if location
      str << latlng if latitude && longitude
      "markers=" << str.map{|v| CGI.escape(v) }.join(PIPE)
    end

    def latlng
      "#{latitude},#{longitude}"
    end
  end
end