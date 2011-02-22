module KPI
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

  include KPI::Configuration
end