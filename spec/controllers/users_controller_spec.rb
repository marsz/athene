require 'spec_helper'

describe UsersController do
  include Restable
  
  it { should route(:get, "/users").to(:action => :index) }
  it { should route(:get, "/users.json").to(:action => :index, :format => :json) }
  
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
