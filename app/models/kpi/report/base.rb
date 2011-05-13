module KPI
  module Report
    class Base
      extend KPI::Report::SuppressMemoization
      extend ActiveSupport::Memoizable

      include KPI::Report::DynamicDefinitions
      
      blacklist :initialize, :collect!, :entries, :time, :title

      def initialize(time=Time.now)
        @time = time
      end
      attr_reader :time

      def collect!
        self.class.defined_kpis.each {|kpi_method| send(kpi_method) }
        self
      end

      def entries
        Enumerator.new do |yielder|
          self.class.defined_kpis.each do |kpi_method|
            result = send(kpi_method)
            yielder.yield(Entry.new(result.shift, result.shift, result.shift))
          end
        end
      end

      def title
        self.class.name
      end
    end
  end
end