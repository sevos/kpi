require 'array/extract_options'

module KPI
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'kpi/18compatibility' if RUBY_VERSION < '1.9'
end