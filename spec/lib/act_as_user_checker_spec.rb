require 'spec_helper'

shared_examples_for "act_as_user_checker" do
  before do
  end
  
  describe "#check_is_enabled" do
    it "user should disable after check" do
      @user_should_disable.enable
      @user_should_disable.enabled?.should be_true
      @user_should_disable.check_is_enabled
      @user_should_disable.enabled?.should be_false
    end
    it "user should enable after check" do
      @user_should_enable.disable
      @user_should_enable.enabled?.should be_false
      @user_should_enable.check_is_enabled
      @user_should_enable.enabled?.should be_true
    end
  end
  
end


describe "all included class" do
  include DataMaker
  before do
    init_all_data
  end
  
  describe User do
    before do
      @site = Site.find_by_domain("wretch") || Factory(:site, :domain => "wretch")
      @user = Factory :user, :site => @site, :site_user_id => "marsz"
      @user_should_disable = Factory :user_should_disabled, :site_id => @site.id
      @user_should_enable = @user
    end
    
    it_should_behave_like "act_as_user_checker"
  end
end