module KPI
  module Report
    module MailDelivery
      def self.included(base)
        base.class_eval 
          blacklist :send!
        end
      end

      def send!
        KPI::Mailer.report(self.collect!).deliver
      end
    end
  end
end