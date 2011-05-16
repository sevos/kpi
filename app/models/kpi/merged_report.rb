module KPI
  class MergedReport
    def initialize(*args, &block)
      options = args.extract_options!
      raise ArgumentError, "Should have any argument" if args.length == 0
      raise Exception unless block_given?
      @_mode = options[:mode] || :&
      @_reports = args
      @_merge = block
    end
    
    def entries
      Enumerator.new do |yielder|
        defined_kpis.each do |kpi_method|
          yielder.yield(send(kpi_method))
        end
      end
    end
  
    def title
      self.class.name
    end
    
    def defined_kpis
      @_reports.map(&:defined_kpis).inject(&@_mode)
    end

    def method_missing(name, *args)
      result = merge_proc_call(name)
      orginal = @_reports.find { |r| r.defined_kpis.include?(name) }.send(name.to_sym)
      description = (orginal.description && result.description ? result.description.gsub("$$", orginal.description) : nil)

      KPI::Entry.new(result.name.gsub("$$", orginal.name),
                     result.value,
                     :description => description,
                     :unit => (result.unit || orginal.unit))
    end
    
    private
    
    def merge_proc_call(name)
      sym_name = name.to_sym
      args = @_mode == :& ? @_reports.map(&sym_name) : begin
        @_reports.map do |report|
          report.defined_kpis.include?(name) ? report.send(name) : nil
        end
      end
      @_merge.call(*args)
    end
  end
end
