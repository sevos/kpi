module KPI
  module Report
    class Merged
      def initialize(*args, &block)
        raise ArgumentError, "Should have any argument" if args.length == 0
        raise Exception unless block_given?
        raise ArgumentError, "Argument must be the same type" unless args.map(&:class).uniq.size == 1
        
        @reports ||= args
        @compare = block
      end
      
      def entries
        Enumerator.new do |yielder|
          defined_kpis.each do |kpi_method|
            result = self.send(kpi_method.to_sym)
            yielder.yield(KPI::Entry.new(*result))
          end
        end
      end

      def title
        self.class.name
      end
      
      def defined_kpis
        @reports.map(&:defined_kpis).inject(&:&)
      end

      def method_missing(name, *args)
        result = @compare.call(*@reports.map(&name.to_sym))
        [0,2].each do |i|
          text = @reports.first.send(name.to_sym)[i]
          result[i] = text ? result[i].gsub!("$$", text) : nil
        end
        result
      end
      

    end
  end
end
