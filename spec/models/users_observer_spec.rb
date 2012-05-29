require 'spec_helper'

describe UsersObserver do
  
  before do
    @user = FactoryGirl.create :user, :is_enabled => true
    @user.is_black.should be_false
    FactoryGirl.create :post, :user => @user
    @user.posts.size.should > 0
    @user.is_black = true
    @user.save
    @user.reload
  end
  
  it "should auto disable if set black" do
    @user.is_enabled.should be_false
  end
  
  it "should auto delete posts if set black" do
    @user.posts.size.should == 0
  end
  
  it "should enable if set is_black true" do
    @user.is_black = false
    @user.save
    @user.is_enabled.should be_true
  end
end
