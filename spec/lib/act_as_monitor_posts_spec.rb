require 'spec_helper'

shared_examples_for "act_as_monitor_posts" do
  include DataMaker
  before do
    @site = @crawler.seed_site
    @data = factory_by_domain(@site.domain)
    @user = FactoryGirl.create :user, @data[:user].merge(:site_id=>@site.id)
  end

  it "scoped: posts_monitoring" do
    @user.update_attributes :monitored_at => nil
    klass = @user.class
    last_user = FactoryGirl.create :user,:site_id=>@site.id,:site_user_id=>"1234",:monitored_at => Time.now - (ActAsMonitorPosts::MONITOR_POSTS_INTERVAL_DAYS * 2).days
    monitored_user = FactoryGirl.create :user,:site_id=>@site.id,:site_user_id=>"4321",:monitored_at => Time.now - 2.hours
    users = klass.posts_monitoring
    users.last.should == last_user
    users.first.should == @user
    users.include?(monitored_user).should be_false
  end

  it "monitored" do
    now = Time.now
    @user.monitored
    @user.monitored_at.should >= now
  end
  
  describe "state mechine testing" do
    before do
      @user.reset_posts_monitoring_state
      ResqueSpec.reset!
    end
    
    it "async_monitor_posts only once" do
      @user.async_monitor_posts
      @user.posts_monitor_idle?.should be_false
      @user.posts_monitor_queuing?.should be_true
      @user.async_monitor_posts
      ActAsMonitorPosts::Worker.should have_queue_size_of(1)
    end
    
    it "after perform state should be idle" do
      @user.async_monitor_posts
      @user.posts_monitor_queuing?.should be_true
      ActAsMonitorPosts::Worker.perform(@user.id)
      @user.reload
      @user.posts_monitor_idle?.should be_true
    end
    
  end
  
  it "#async_monitor_posts" do
    ResqueSpec.reset!
    @user.async_monitor_posts
    ActAsMonitorPosts::Worker.should have_queued(@user.id).in(:monitor_posts)
    ActAsMonitorPosts::Worker.should have_queue_size_of(1)
  end
  
  it "monitor posts" do
    now = Time.now
    posts = @user.monitor_posts
    limit = @data[:user_posts_over_limit] || 0
    posts.size.should > limit
    posts.each { |post| post.new_record?.should == false}
    posts.first.destroy
    new_posts = @user.monitor_posts
    new_posts.size.should_not == posts.size
    new_posts.size.should >= 1
    @user.monitored_at.should >= now
  end
  
  it "monitor posts bad user" do
    bad_user = FactoryGirl.create :user,:site_id=>@site.id,:site_user_id=>"marsz1234",:monitored_at => nil
    bad_user.monitor_posts.size.should == 0
    bad_user.monitored_at.should == nil
  end
  
end

describe "crawlers" do
  Site::CRAWLERS.each do |crawler_kclass|
    describe "#{crawler_kclass.to_s}" do
      before do
        @crawler = crawler_kclass.new
      end
      it_should_behave_like "act_as_monitor_posts"
    end
  end
end
