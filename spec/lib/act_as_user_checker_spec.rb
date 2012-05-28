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
  
  pending "scope enabled_checking_by_avatar"
  
  describe "scope enabled_checking" do
    before do 
      @check_users = [FactoryGirl.create(:user_for_check, :checked_at => nil), FactoryGirl.create(:user_for_check)]
      @un_check_users = [
        FactoryGirl.create(:user_for_check, :check_state => "queuing"),
        FactoryGirl.create(:user_for_check, :check_state => "checking"),
        FactoryGirl.create(:user_for_check, :checked_at => Time.now-(User::CHECK_WITHIN_DAYS-1).day),
      ]
    end
    it "should include and not included users" do
      user_ids = User.enabled_checking.map{|u|u.id}
      @check_users.each do |user|
        user_ids.include?(user.id).should be_true
      end
      @un_check_users.each do |user|
        user_ids.include?(user.id).should be_false
      end
    end
  end
  describe "state mechine testing" do
    before do
      @user.reset_check_state
      ResqueSpec.reset!
    end
    
    it "async_check_is_enabled only once" do
      @user.async_check_is_enabled
      @user.check_state_idle?.should be_false
      @user.check_state_queuing?.should be_true
      @user.async_check_is_enabled
      ActAsUserChecker::Worker.should have_queue_size_of(1)
      User.enabled_checking.map{|u|u.id}.include?(@user.id).should be_false
    end
    
    it "after perform state should be idle" do
      @user.async_check_is_enabled
      @user.check_state_queuing?.should be_true
      User.enabled_checking.map{|u|u.id}.include?(@user.id).should be_false
      ActAsUserChecker::Worker.perform(@user.id)
      @user.reload
      @user.check_state_idle?.should be_true
      User.enabled_checking.map{|u|u.id}.include?(@user.id).should be_false
    end
  end
  
  it "#async_check_is_enabled" do
    ResqueSpec.reset!
    @user.async_check_is_enabled
    ActAsUserChecker::Worker.should have_queued(@user.id).in(:check_users)
    ActAsUserChecker::Worker.should have_queue_size_of(1)
  end
end


describe "all included class" do
  include DataMaker
  before do
    init_all_data
  end
  
  describe User do
    before do
      @site = Site.find_by_domain("wretch") || FactoryGirl.create(:site, :domain => "wretch")
      @user = FactoryGirl.create :user, :site => @site, :site_user_id => "marsz"
      @user_should_disable = FactoryGirl.create :user_should_disabled, :site_id => @site.id
      @user_should_enable = @user
    end
    
    it_should_behave_like "act_as_user_checker"
  end
end