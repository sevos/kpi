module KPI
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

  mattr_accessor :app_name
  @@app_name = "Your app"

  mattr_accessor :mail_from
  @@mail_from = "example@example.com"

  mattr_accessor :mail_to
  @@mail_to = "example@example.com"

  def self.configure
    yield self
  end
end