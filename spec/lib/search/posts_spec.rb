require 'spec_helper'

describe Search::Posts do
  before do
    @post = Factory :post, :title => "5fproisvertgoooooooood"
  end
  it "#to_api_hash" do
    hash = @post.to_api_hash
    hash.key?(:title).should be_true
    hash.key?(:url).should be_true
    hash.key?(:date).should be_true
    hash.key?(:id).should be_true
  end
  describe "search" do
    it ":q" do
      post2 = Factory :post
      posts = Post.search(:q => "pro")
      posts.map{|p|p.id}.include?(@post.id).should be_true
      posts.map{|p|p.id}.include?(post2.id).should be_false
    end
    describe ":site" do
      before do
        @site = Factory :site, :domain => :wretch
        @posts = [Factory(:post, :site => @site), Factory(:post, :site => @site)]
      end
      it "should match :site" do
        ids = Post.search(:site => :wretch).map{|p|p[:id]}
        ids.include?(@posts.first.id).should be_true
        ids.include?(@posts.last.id).should be_true
        ids.include?(@post.id).should be_false
      end
      it ":post" do
        post = Factory :post, :site => @site, :site_post_id => "12345"
        ids = Post.search(:site => :wretch, :post => "12345").map{|p|p[:id]}
        ids.size.should == 1
        ids.include?(post.id).should be_true
      end
      it ":user" do
        user = Factory :user, :site => @site, :site_user_id => "mmm123"
        post = Factory :post, :site => @site, :user => user
        ids = Post.search(:site => :wretch, :user => "mmm123").map{|p|p[:id]}
        ids.size.should == 1
        ids.include?(post.id).should be_true
      end
    end
  end
end