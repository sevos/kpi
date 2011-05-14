module KPI
  class Entry
    attr_reader :name, :value, :description, :unit
    def initialize(*args)
      options = args.extract_options!
      raise ArgumentError, "Wrong number of arguments (#{args.count} of 2)" unless args.count == 2
      @name, @value = args
      @description = options[:description]
      @unit = options[:unit]
    end
    
    def to_a
      [@title, @value, @description, @unit].compact
    end
  end
end