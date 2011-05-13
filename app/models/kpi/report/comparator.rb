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
            result = self.send(kpi_method.to_sym)
            yielder.yield(KPI::Entry.new(*result))
          end
        end
      end

      def title
        self.class.name
      end

      def method_missing(name, *args)
        @compare.call(*@reports.map(&name.to_sym))
      end

    end
  end
end
