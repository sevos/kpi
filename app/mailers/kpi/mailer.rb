class KPI::Mailer < ActionMailer::Base
  default :from => "TimeBacus <timebacus@timebacus.com>"
  default :to => "artur.roszczyk@gmail.com, bart.mouse@gmail.com"

  def report(kpi_report)
    @entries = kpi_report.entries
    @time = kpi_report.time
    @title = kpi_report.title

    mail :subject => "[TimeBacus KPI][#{@time.to_date.to_s(:db)}] #{@title}"
  end
end
