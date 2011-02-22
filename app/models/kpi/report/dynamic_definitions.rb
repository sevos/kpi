module KPI
  module Report
    module DynamicDefinitions
      def self.included(base)
        base.class_eval do
          @@do_not_memoize = [] # [:initialize, :collect!, :entries, :time, :title]
        end
      end
      
      def method_added(name)
        unless self.method_blacklisted?(name) || suppressed_memoization?
          self.defined_kpis << name
          suppress_memoization { memoize name }
        end
      end

      def method_blacklisted?(name)
        @@do_not_memoize.include?(name) || name =~ /_unmemoized_/
      end

      def blacklist(*methods)
        @@do_not_memoize.push *methods
      end

      def self.defined_kpis
        @kpi_methods ||= []
      end
    end
  end
end