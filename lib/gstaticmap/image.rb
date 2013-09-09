module GStaticMap

  class Image
    require 'tempfile'
    require 'securerandom'
    require 'cgi'
    require 'open-uri'

    PIPE = CGI.escape('|')
    ALPHABET = ('A'..'Z').to_a
    URL = "http://maps.google.com/maps/api/staticmap"
    KEY = ""


    attr_accessor :center,
      :zoom,
      :size,
      :sensor,
      :markers,
      :maptype,
      :scale,
      :format,
      :language,
      :markers_label_type,
      :render_path,
      :file_path


    def initialize(options={})
      @markers            = options[:markers]            || []
      @size               = options[:size]               || '500x500'
      @sensor             = options[:sensor]             || true
      @zoom               = options[:zoom]               || nil
      @center             = options[:center]             || nil
      @maptype            = options[:maptype]            || 'road'
      @scale              = options[:scale]              || 1
      @format             = options[:format]             || 'jpg'
      @language           = options[:language]           || 'ru'
      @markers_label_type = options[:markers_label_type] || :none
      @render_path        = options[:render_path]        || false
      @file_path          = options[:file_path]          || nil
      @key                = options[:key]                || KEY
    end

    def file

      image_file = if file_path
        File.open(@file_path, "w")
      else
        Tempfile.new([SecureRandom.hex(5), ".#{format}"])
      end

      image_file.binmode
      open(direct_url) do |io|
        image_file.write io.read
      end
      image_file.rewind
      image_file
    end

    def direct_url
      "#{URL}?#{params}".strip
    end

    private

      def params
        query = { size:     size,
                  center:   center,
                  zoom:     zoom,
                  sensor:   sensor,
                  maptype:  maptype,
                  format:   format,
                  scale:    scale,
                  key:      @key,
                  language: language }
        result = query.reject { |k,v| v.nil? }.collect{|k,v| "#{k}=#{CGI.escape(v.to_s)}"} * '&'
        result += "&path=#{path}" if render_path # need this beacuse to_param escapes ',' symbol
        result += "&#{marker_params}"  if markers.any?
        result
      end

      def marker_params
        if markers.any?
          add_labels_to_markers!
          markers.map{ |marker| marker.to_params }.join('&').gsub("=#{PIPE}", '=')
        else
          nil
        end
      end

      def add_labels_to_markers!
        case markers_label_type
        when :alpabetical
          @markers.each_with_index{ |x,i| x.label = ALPHABET[i]}
        when :numerical
          @markers.each_with_index{ |x,i| x.label = i.next.to_s}
        end
      end

      def path
        markers.map(&:latlng).join(PIPE)
      end

  end
end
