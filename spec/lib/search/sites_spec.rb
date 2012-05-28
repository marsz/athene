require 'spec_helper'

describe Search::Sites do
  before do
    @site = FactoryGirl.create :site
  end
  it "#to_api_hash" do
    hash = @site.to_api_hash
    hash.key?(:id).should be_true
    hash.key?(:domain).should be_true
    hash.key?(:name).should be_true
  end
  describe "meta_search" do
    it ":site" do
      @site2 = FactoryGirl.create :site, :domain => :wretch
      ids = Site.meta_search(:site => :wretch).map{|p|p[:id]}
      ids.size.should == 1
      ids.include?(@site2.id).should be_true
      ids.include?(@site.id).should be_false
    end
    pending "params[:search]"
  end
end