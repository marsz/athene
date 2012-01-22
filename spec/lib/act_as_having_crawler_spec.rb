require 'spec_helper'

shared_examples_for "act_as_having_crawler" do
  include DataMaker
  before do
    @site = @crawler.seed_site
    @urls = factory_by_domain(@site.domain)[:urls_for_find_site]
  end
  it "find_by_url" do
    @urls.each do |url|
      Site.find_by_url(url).id.should == @site.id
    end
  end
  describe "#crawler" do
    it "should work" do
      @site.crawler.class.should == @crawler.class
    end
    it "should return nil if class not exists" do
      @site.domain = "abc"
      @site.crawler.should be_nil
    end
  end
end

describe "crawlers" do
  Site::CRAWLERS.each do |crawler_kclass|
    describe "#{crawler_kclass.to_s}" do
      before do
        @crawler = crawler_kclass.new
      end
      it_should_behave_like "act_as_having_crawler"
    end
  end
end
