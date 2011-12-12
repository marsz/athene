require 'spec_helper'

shared_examples_for "act_as_is_enabled" do
  before do
    @obj.enable
    @obj_last.disable
    @klass = @obj.class
  end
  
  describe "scopes" do
    it "enabled" do
      @klass.enabled.last.should == @obj
      @obj_last.enable
      @klass.enabled.last.should == @obj_last
    end
  end
  
  describe "instances" do
    it "enable" do
      @obj_last.enabled?.should be_false
      @obj_last.enable.should be_true
      @obj_last.enabled?.should be_true
    end
    
    it "disable" do
      @obj.enabled?.should be_true
      @obj.disable.should be_true
      @obj.enabled?.should be_false
    end
  end
end


describe "all included class" do
  include DataMaker
  before do
    init_all_data
  end
  
  describe User do
    before do
      @obj = @user
      @obj_last = Factory :user_disabled, :site_id => @site.id
    end
    
    it_should_behave_like "act_as_is_enabled"
  end
end