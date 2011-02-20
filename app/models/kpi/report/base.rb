module KPI
  module Report
    class Base
      @@do_not_memoize = [:initialize, :collect!, :entries, :time, :title]
      extend KPI::Report::SuppressMemoization
      extend ActiveSupport::Memoizable
      
      def self.method_added(name)
        unless self.method_blacklisted?(name) || suppressed_memoization?
          self.defined_kpis << name
          suppress_memoization { memoize name }
        end
      end

      def self.method_blacklisted?(name)
        @@do_not_memoize.include?(name) || name =~ /_unmemoized_/
      end

      def self.defined_kpis
        @kpi_methods ||= []
      end

      def self.collect_and_send!
        KPI::Mailer.report(self.new.tap(&:collect!)).deliver
      end

      def initialize(time=Time.now)
        @time = time
      end
      attr_reader :time

      def collect!
        self.class.defined_kpis.each {|kpi_method| send(kpi_method) }
        self.class.defined_kpis.count
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