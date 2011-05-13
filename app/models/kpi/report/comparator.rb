module KPI
  module Report
    class Comparator
      extend KPI::Report::SuppressMemoization
      extend ActiveSupport::Memoizable

      def initialize(*args, &block)
        raise ArgumentError, "Should have any argument" if args.length == 0
        raise Exception unless block_given?
        raise ArgumentError, "Argument must be the same type" unless args.map(&:class).uniq.size == 1
        
        @reports ||= args
        @compare = block
      end
      
      def entries
        Enumerator.new do |yielder|
          @reports.first.class.defined_kpis.each do |kpi_method|
            result = @compare.call(*@reports.map(&:"#{kpi_method}"))
            yielder.yield(KPI::Entry.new(*result))
          end
        end
      end

      def title
        self.class.name
      end

      def method_missing(name, *args)
        @reports.first.class.defined_kpis.each do |kpi_method|
          @compare.call(*@reports.map(&:"#{kpi_method}"))
        end
      end

    end
  end
end
