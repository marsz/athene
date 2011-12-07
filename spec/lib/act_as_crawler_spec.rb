require 'spec_helper'

shared_examples_for "act_as_crawler" do
  include DataMaker
  before do
    @site = @crawler.seed_site
    @users_monitor_parser = @crawler.seed_users_monitor_parser(@site)
    @data = factory_by_domain(@site.domain)
  end
  describe "seed" do
    it "seed_site" do
      @site.new_record?.should == false
    end
    it "seed_users_monitor_parser" do
      @users_monitor_parser.new_record?.should == false
    end
    it "seed_users_monitor_urls" do
      urls = @crawler.seed_users_monitor_urls(@users_monitor_parser)
      urls.size.should > 0
      urls.each do |url| 
        url.new_record?.should == false
        url.is_a?(UsersMonitorUrl).should == true
        url.parser.id.should == @users_monitor_parser.id
      end
    end
  end
  
  describe "monitor users" do
    before do
      @users_urls = @data[:users_urls]
    end
    it "parse_site_user_id_from_url" do
      @users_urls.each do |url|
        site_user_id = @crawler.parse_site_user_id_from_url(url)
        site_user_id.blank?.should == false
        site_user_id.size.should > 0
      end
    end
    it "monitor_users" do
      @users_urls.each_with_index do |url, index|
        Factory :users_monitor_url, :url => url, :parser_id => @users_monitor_parser.id, :label => "url #{index}", :site_id => @site.id
      end
      users = @crawler.monitor_users
      users.size.should > 0
      users.each {|user| user.new_record?.should == false}
      users.last.destroy
      @crawler.monitor_users.size.should >= 1
    end
  end
  
  describe "monitor posts" do
    before do
      @user = Factory :user, :site_id => @site.id, :site_user_id => @data[:user][:site_user_id]
      # @posts_urls_size = @data[:user][:posts_page_size]
      @posts_urls = @data[:posts_urls]
      @post_urls = @data[:post_urls]
      @user_posts_url = @data[:user_posts][:url]
      @user_posts_size = @data[:user_posts][:size]
    end
    it "parse_posts_page_size" do
      @posts_urls.each do |hash|
        content = Net::HTTP.get(URI.parse(hash[:url]))
        @crawler.parse_posts_page_size(content).should >= hash[:size]
      end
    end
    it "url_posts" do
      content = Net::HTTP.get(URI.parse(@crawler.url_posts(@user)))
      content.is_a?(String).should == true
      content.size.should > 0
    end
    it "parse_site_post_id_from_url" do 
      @post_urls.each do |url|
        site_post_id = @crawler.parse_site_post_id_from_url(url)
        site_post_id.is_a?(String).should == true
        site_post_id.size.should > 0
      end
    end
    it "parse_posts_from_posts_page" do
      content = Net::HTTP.get(URI.parse(@user_posts_url))
      posts = @crawler.parse_posts_from_posts_page(content)
      posts.size.should >= @user_posts_size
      posts.each do |post|
        post.key?(:title).should == true
        post.key?(:date).should == true
        post.key?(:url).should == true
        post[:url].index("http://").should == 0
      end
    end
  end
end

describe "crawlers" do
  Site::CRAWLERS.each do |crawler_kclass|
    describe "#{crawler_kclass.to_s}" do
      before do
        @crawler = crawler_kclass.new
      end
      it_should_behave_like "act_as_crawler"
    end
  end
end
