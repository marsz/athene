require 'spec_helper'

shared_examples_for "act_as_fetcher" do
  describe "instance methods" do
    
    it "can fetch content" do
      @url = "http://www.google.com.tw"
      @obj.fetch(@url).length.should > 0
    end
    
    it "can fetch status" do
      @url = "http://www.google.com.tw"
      @obj.fetch_status(@url).should == 200
    end
    
    it "can fetch status error" do
      @url = "http://jim1997913.pixnet.net/blog"
      @obj.fetch_status(@url).should == 403
    end
    
  end
end

describe "all included classes" do
  include DataMaker
  before do
    init_all_data
  end
  
  describe Site do
    before do
      @obj = @site
    end
    it_should_behave_like "act_as_fetcher"
  end

  describe User do
    before do
      @obj = @user
    end
    it_should_behave_like "act_as_fetcher"
  end
  
end