class ReportMailer < ActionMailer::Base
  include ActAsReport
  # default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.daily.subject
  #
  def daily
    @yesterday = Time.now.to_date-1.day
    @report = daily_by_date(@yesterday)
    vars = get_config[:daily]
    vars[:subject] = "#{@yesterday} #{vars[:subject]}"
    mail(vars)
  end
  
  private
  
  def get_config
    YAML.load(File.open("#{Rails.root}/config/email.yml"))[Rails.env][:report]
  end
end
