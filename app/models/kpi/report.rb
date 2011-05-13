module KPI
  class Report
    extend KPI::Report::SuppressMemoization
    extend ActiveSupport::Memoizable
 
    include KPI::Report::DynamicDefinitions
    
    blacklist :initialize, :collect!, :entries, :time, :title, :defined_kpis
 
    def initialize(*args)
      options = args.extract_options!
      @time = options[:time] || Time.now
    end
    attr_reader :time
 
    def collect!
      self.defined_kpis.each {|kpi_method| send(kpi_method) }
      self
    end
 
    def entries
      Enumerator.new do |yielder|
        self.class.defined_kpis.each do |kpi_method|
          result = send(kpi_method)
          yielder.yield(Entry.new(*result))
        end
      end
    end
 
    def title
      self.class.name
    end
 
    def defined_kpis
      self.class.defined_kpis
    end
  end
end