require "spec_helper"

describe ReportMailer do
  it "#daily" do
    mail = ReportMailer.daily.deliver!
    mail.body.should match((Time.now.to_date-1.day).to_s)
    mail.subject.length.should > 0
  end
end
