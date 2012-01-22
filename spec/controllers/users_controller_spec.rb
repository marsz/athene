require 'spec_helper'

describe UsersController do
  include Restable
  
  it { should route(:get, "/users").to(:action => :index) }
  it { should route(:get, "/users.json").to(:action => :index, :format => :json) }
  
  describe "post create" do
    before do
      @site = Factory :site, :domain => :wretch
    end
    it "should be created with :site & :user" do
      post :create, :site => @site.domain, :user => "marsz"
      response.should redirect_to(user_path(assigns[:user]))
    end
    it "should not be created with exists data" do
      user = Factory :user, :site_user_id => "marsz", :site => @site
      post :create, :site => @site.domain, :user => user.site_user_id
      hash = ActiveSupport::JSON.decode(response.body)
      hash.key?("user").should be_true
      hash["user"]["id"].should == user.id
    end
    it "should not be created with upper case exists data" do
      user = Factory :user, :site_user_id => "MARSZ", :site => @site
      post :create, :site => @site.domain, :user => user.site_user_id
      hash = ActiveSupport::JSON.decode(response.body)
      hash.key?("user").should be_true
      hash["user"]["id"].should == user.id
    end
    it "should not be created with non-exists site" do
      post :create, :site => :foo, :user => :bar
      ActiveSupport::JSON.decode(response.body).should be_a_kind_of(Hash)
    end
  end
  
  describe "get show" do
    before do
      @user = Factory :user
    end
    it "exists user" do
      get :show, :id => @user.id
      ActiveSupport::JSON.decode(response.body).should_not be_nil
    end
    it "non-exists user" do
      expect {
        get :show, :id => (@user.id-1)
      }.to raise_error
    end
  end
  
  describe "get index" do
    def search_results opts = {}
      search(opts)[:users]
    end
    before do
      @user = Factory :user, :site_user_id => "5fproisvertgoooooooood"
    end
    it "json output" do
      result = search
      result.key?(:users).should be_true
      result[:users].should be_a_kind_of(Array)
      result[:users].first[:id].should == @user.id
      result[:users].first[:site_user_id].should == @user.site_user_id
      result[:users].first.key?(:site).should be_true
      result[:total].should == 1
    end
    describe "with params[:site]" do
      before do
        @site = Factory :site, :domain => :wretch
        @user = [Factory(:user, :site => @site), Factory(:user, :site => @site)]
      end
      it "params[:site]" do
        should_match_querys User, :site => :wretch
      end
      it "params[:user]" do
        user = Factory :user, :site => @site, :site_user_id => "mmm123"
        should_match_querys User, :site => :wretch, :user => "mmm123"
      end
    end
  end
end
