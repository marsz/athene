require 'spec_helper'

describe PostsController do
  it { should route(:get, "/posts").to(:action => :index) }
  it { should route(:get, "/posts.json").to(:action => :index, :format => :json) }
  
  describe "get index" do
    before do
      @post = Factory :post, :title => "5fproisvertgoooooooood"
    end
    it "json output" do
      get :index, :format => :json
      result = ActiveSupport::JSON.decode(response.body)
      result.should be_a_kind_of(Array)
      result.first["id"].should == @post.id
    end
    it "with params[:q]" do
      post2 = Factory :post
      get :index, :q => "pro"
      posts = assigns[:posts]
      posts.map{|p|p.id}.include?(@post.id).should be_true
      posts.map{|p|p.id}.include?(post2.id).should be_false
    end
  end
end
