module KPI
  module Generators
    class InstallGenerator < Rails::Generators::Base
      namespace "kpi:install"
      source_root File.expand_path('../templates', __FILE__)
      desc "Creates a KPI initializer."

      def copy_initializer
        template "initializer.rb", "config/initializers/kpi.rb"
      end
    end
  end
end
    