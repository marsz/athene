require 'spec_helper'

describe Search::Sites do
  before do
    @site = Factory :site
  end
  it "#to_api_hash" do
    hash = @site.to_api_hash
    hash.key?(:id).should be_true
    hash.key?(:domain).should be_true
    hash.key?(:name).should be_true
  end
  describe "search" do
    it ":site" do
      @site2 = Factory :site, :domain => :wretch
      ids = Site.search(:site => :wretch).map{|p|p[:id]}
      ids.size.should == 1
      ids.include?(@site2.id).should be_true
      ids.include?(@site.id).should be_false
    end
  end
end