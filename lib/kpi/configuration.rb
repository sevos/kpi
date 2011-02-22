module KPI
  module Configuration
    def self.included(base)
      base.class_eval do
        
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
    end
  end
end