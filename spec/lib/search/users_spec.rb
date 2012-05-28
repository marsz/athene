require 'spec_helper'

describe Search::Users do
  before do
    @user = FactoryGirl.create :user
  end
  it "#to_api_hash" do
    hash = @user.to_api_hash
    hash.key?(:site_user_id).should be_true
    hash.key?(:id).should be_true
    hash.key?(:posts_count).should be_true
  end
  describe "meta_search" do
    describe ":site" do
      before do
        @site = FactoryGirl.create :site, :domain => :wretch
        @users = [FactoryGirl.create(:user, :site => @site), FactoryGirl.create(:user, :site => @site)]
      end
      it "should match :site" do
        ids = User.meta_search(:site => :wretch).map{|p|p[:id]}
        ids.include?(@users.first.id).should be_true
        ids.include?(@users.last.id).should be_true
        ids.include?(@user.id).should be_false
      end
      it ":user" do
        user = FactoryGirl.create :user, :site => @site, :site_user_id => "12345"
        ids = User.meta_search(:site => :wretch, :user => "12345").map{|p|p[:id]}
        ids.size.should == 1
        ids.include?(user.id).should be_true
      end
    end
    pending "params[:search]"
  end
  pending "avatar"
end