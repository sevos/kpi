module KPI
  module Report
    module SuppressMemoization
      def suppress_memoization
        Thread.current[:'suppress memoization'] = true
        yield
      ensure
        Thread.current[:'suppress memoization'] = false
      end
      
      def suppressed_memoization?
        Thread.current[:'suppress memoization']
      end
    end
  end
end