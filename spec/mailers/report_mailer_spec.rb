require "spec_helper"

describe ReportMailer do
  describe "daily" do
    let(:mail) { ReportMailer.daily }

    it "renders the headers" do
      mail.subject.should eq("Daily")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
