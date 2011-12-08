require 'spec_helper'

shared_examples_for "act_as_tags_stripable" do
  describe "instance methods" do
    it "should strip tag automatically" do
      @obj.send("#{@column}=", "foo <b class=\"ff\">bar</b><br/><br /><br / >")
      @obj.save
      @obj.send("title").should == "foo bar"
    end
  end
end


describe "all included classes" do
  include DataMaker
  before do
    init_all_data
  end
  
  describe Post do
    before do
      @obj = @post
      @column = :title
    end
    it_should_behave_like "act_as_tags_stripable"
  end
end