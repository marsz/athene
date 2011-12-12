require 'spec_helper'

shared_examples_for "act_as_monitor_posts" do
  include DataMaker
  before do
    @site = @crawler.seed_site
    @data = factory_by_domain(@site.domain)
    @user = Factory :user, @data[:user].merge(:site_id=>@site.id)
  end

  it "monitored" do
    now = Time.now
    @user.monitored
    @user.monitored_at.should >= now
  end
  
  it "monitor posts" do
    now = Time.now
    posts = @user.monitor_posts
    posts.size.should > 0
    posts.each { |post| post.new_record?.should == false}
    posts.last.destroy
    new_posts = @user.monitor_posts
    new_posts.size.should_not == posts.size
    new_posts.size.should >= 1
    @user.monitored_at.should >= now
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
