module KPI
  module Generators
    class KPIGenerator < Rails::Generators::NamedBase
      namespace "kpi"
      source_root File.expand_path("../templates", __FILE__)
    end
  end
end