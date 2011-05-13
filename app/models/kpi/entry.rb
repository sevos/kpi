module KPI
  class Entry
    attr_reader :name, :value, :description
    def initialize(*args)
      options = args.extract_options!
      raise ArgumentError, "Wrong number of arguments (#{args.count} of 2)" unless args.count == 2
      @name, @value = args
      @description = options[:description]
    end
    
    def to_a
      [@title, @value, @description].compact
    end
  end
end