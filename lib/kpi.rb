require 'array/extract_options'

module KPI
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'kpi/18compatibility' if RUBY_VERSION < '1.9'
  require 'kpi/memoizable'

  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/entry')
  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/dynamic_definitions')
  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/suppress_memoization')
  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report')
  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/merged_report')
end
