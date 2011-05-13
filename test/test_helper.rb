$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'minitest/autorun'

require 'active_support'
require 'action_mailer'
require 'kpi'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

require File.join(File.dirname(__FILE__), '..', 'lib/kpi/configuration')
require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/entry')
require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/dynamic_definitions')
require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/suppress_memoization')
require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/base')
require File.join(File.dirname(__FILE__), '..', 'app/models/kpi/report/merged')

