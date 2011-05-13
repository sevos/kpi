module KPI
  module Report
    class Comparator
      extend KPI::Report::SuppressMemoization
      extend ActiveSupport::Memoizable

      include KPI::Report::DynamicDefinitions
      
      blacklist :initialize, :average, :title

      def initialize(*args)
        @comparator ||= []
        
        args.each do |arg|
          @comparator << arg 
        end

      end

      def average
        @comparator.instance_eval { reduce(:+) / size.to_f }
      end

      def title
        self.class.name
      end
    end
  end
end
