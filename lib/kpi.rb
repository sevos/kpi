module KPI
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

  require 'kpi/configuration'
  include KPI::Configuration
end