require 'spec_helper'

describe UsersMonitorUrl do
  include DataMaker
  before do
    init_all_data
  end
  it {should belong_to(:parser)}
  it {should belong_to(:site)}
  it {should validate_uniqueness_of(:url)}
  it {should validate_presence_of(:label)}
  it {should validate_presence_of(:site_id)}
  it {should validate_presence_of(:parser_id)}
  
  it "monitored" do
    before_monitoed = Time.now
    @users_monitor_url.monitored
    (before_monitoed <= @users_monitor_url.monitored_at).should == true
  end
end
