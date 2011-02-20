require 'kpi'
require 'rails'

module Cheese
  class Engine < Rails::Engine

    # Config defaults
    config.mount_at = '/'
    
    
    # Check the gem config
    initializer "check config" do |app|

      # make sure mount_at ends with trailing slash
      config.mount_at += '/'  unless config.mount_at.last == '/'
    end
    
  end
end