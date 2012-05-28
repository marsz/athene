require 'spec_helper'

describe PostsController do
  include Restable
  
  it { should route(:get, "/posts").to(:action => :index) }
  it { should route(:get, "/posts.json").to(:action => :index, :format => :json) }
  
  describe "get index" do
    def search_results opts = {}
      search(opts)[:posts]
    end
    before do
      @post = FactoryGirl.create :post, :title => "5fproisvertgoooooooood"
    end
    it "json output" do
      result = search
      result.key?(:posts).should be_true
      result[:posts].should be_a_kind_of(Array)
      result[:posts].first[:id].should == @post.id
      result[:posts].first.key?(:user).should be_true
      result[:posts].first.key?(:site).should be_true
      result[:total].should == 1
    end
    it "with params[:q]" do
      post2 = FactoryGirl.create :post
      should_match_querys Post, :q => "pro"
    end
    describe "with params[:site]" do
      before do
        @site = FactoryGirl.create :site, :domain => :wretch
        @posts = [FactoryGirl.create(:post, :site => @site), FactoryGirl.create(:post, :site => @site)]
      end
      it "params[:site]" do
        should_match_querys Post, :site => :wretch
      end
      it "params[:post]" do
        post = FactoryGirl.create :post, :site => @site, :site_post_id => "12345"
        should_match_querys Post, :site => :wretch, :post => "12345"
      end
      it "params[:user]" do
        user = FactoryGirl.create :user, :site => @site, :site_user_id => "mmm123"
        post = FactoryGirl.create :post, :site => @site, :user => user
        should_match_querys Post, :site => :wretch, :user => "mmm123"
      end
    end
  end
end
