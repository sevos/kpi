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
      # takes all reports and uses & (default) or | operator for inject function
      # to build list of defined KPIs
      @_reports.map(&:defined_kpis).inject(&@_mode).map(&:to_sym)
    end

    def method_missing(name, *args)
      return kpi_exists?($1) if (/(.*)\?/ =~ name.to_s)                  # check if KPI exists in report if name of missing method has trailing '?'
      result = merge_proc_call(name)                                     
      orginal = @_reports.find(&:"#{name}?").send(name)                  # find first report having requested KPI
      description = if orginal.description && result.description         # if description exists in orginal and result Entries
                      result.description.gsub("$$", orginal.description)
                    else nil
                    end

      KPI::Entry.new(result.name.gsub("$$", orginal.name),
                     result.value,
                     :description => description,
                     :unit => (result.unit || orginal.unit),
                     :important => (result.important? || orginal.important?))
    end
    
    private

    def kpi_exists?(name)    
      self.defined_kpis.include?(name.to_sym)
    end

    def merge_proc_call(name)
      sym_name = name.to_sym
      args = @_mode == :& ? @_reports.map(&sym_name) : begin # if report is in intersection mode, query for an KPI, otherwise
        @_reports.map do |report|                            #   for each report
          report.send("#{name}?") ? report.send(name) : nil  #     if it has requested kpi return it's result, otherwise: nil
        end
      end
      @_merge.call(*args)                                    # call merge proc with according KPIs
    end
  end
end
