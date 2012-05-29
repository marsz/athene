require 'spec_helper'

describe UsersObserver do
  
  before do
    @user = FactoryGirl.create :user
  end
  
  it "should auto disable if set black" do
    @user.is_black.should be_false
    @user.is_black = true
    @user.save
    @user.is_enabled.should be_false
  end
end
