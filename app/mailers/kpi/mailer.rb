class KPI::Mailer < ActionMailer::Base
  default :from => KPI.mail_from
  default :to => KPI.mail_to

  def report(kpi_report)
    @entries = kpi_report.entries
    @time = kpi_report.time
    @title = kpi_report.title

    mail :subject => "[#{KPI.app_name} KPI][#{@time.to_date.to_s(:db)}] #{@title}"
  end
end
