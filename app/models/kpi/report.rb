module KPI
  class Report
    extend KPI::Report::SuppressMemoization
    extend ActiveSupport::Memoizable
 
    include KPI::Report::DynamicDefinitions
    
    blacklist :initialize, :collect!, :entries, :time, :title, :defined_kpis, :result
 
    def initialize(*args)
      @options = args.extract_options!
      @time = @options[:time] || Time.now
    end
    attr_reader :time
 
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
 
    def title
      self.class.name
    end
 
    def defined_kpis
      self.class.defined_kpis
    end
    
    def result(*args)
      KPI::Entry.new *args
    end
  end
end