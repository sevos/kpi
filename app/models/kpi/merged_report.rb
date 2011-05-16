module KPI
  class MergedReport
    
    def initialize(*args, &block)
      raise ArgumentError, "Should have any argument" if args.length == 0
      raise Exception unless block_given?
      raise ArgumentError, "Argument must be the same type" unless args.map(&:class).uniq.size == 1

      @reports ||= args
      @compare = block
    end
    
    def entries
      Enumerator.new do |yielder|
        defined_kpis.each do |kpi_method|
          yielder.yield(send(kpi_method))
        end
      end
    end
  
    def title
      self.class.name
    end
    
    def defined_kpis
      @reports.map(&:defined_kpis).inject(&:&).map(&:to_sym)
    end
     
    def kpi_exists?(name)    
      self.defined_kpis.include?(name.to_sym)
    end

    def method_missing(name, *args)
      return self.kpi_exists?($1) if (/(.*)\?/ =~ name.to_s)
      result = @compare.call(*@reports.map(&name.to_sym))
      orginal = @reports.first.send(name.to_sym)
      description = (orginal.description && result.description ? result.description.gsub("$$", orginal.description) : nil)

      KPI::Entry.new(result.name.gsub("$$", orginal.name),
                     result.value,
                     :description => description,
                     :unit => (result.unit || orginal.unit))
    end
  end
end
