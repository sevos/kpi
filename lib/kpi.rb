module KPI
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/entry')
  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/suppress_memoization')
  require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/base')
  require File.join(File.dirname(__FILE__), '..', 'app/mailers/kpi/mailer')
end