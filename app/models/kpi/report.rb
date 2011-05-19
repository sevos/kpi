module KPI
  class Report
    extend KPI::Report::SuppressMemoization
    extend ActiveSupport::Memoizable
 
    include KPI::Report::DynamicDefinitions
    
    blacklist :initialize, :collect!, :entries, :time, :title, :defined_kpis, :result, :method_missing
 
    def initialize(*args)
      @options = args.extract_options!
      @time = @options[:time] || Time.now
      @title = @options[:title] || self.class.name
    end
    attr_reader :time, :title
 
    def collect!
      self.defined_kpis.each {|kpi_method| send(kpi_method) }
      self
    end
 
    def entries
      Enumerator.new do |yielder|
        self.class.defined_kpis.each do |kpi_method|
          yielder.yield(send(kpi_method))
        end
      end
    end
 
    def defined_kpis
      self.class.defined_kpis.map(&:to_sym)
    end

    def result(*args)
      KPI::Entry.new *args
    end
    
    def method_missing(name, *args)
      # check if KPI exists in report if name of missing method has trailing '?'
      return kpi_exists?($1.to_sym) if (/(.*)\?/ =~ name.to_s)
      super
    end
    
    private
    
    def kpi_exists?(name)    
      self.defined_kpis.include?(name.to_sym)
    end
  end
end
