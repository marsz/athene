require 'spec_helper'

describe ReportsController do
  integrate_views
  describe "routes" do
    it { should route(:get, "/reports").to(:action => :index) }
  end
  describe "get #index" do
    it "no params" do
      get :index
      response.should be_success
      response.body.should match(Time.now.to_date.to_s)
    end
    it "with :date" do
      get :index, :date => "2012-12-12"
      response.should be_success
      response.body.should match("2012-12-12")
    end
  end
end
