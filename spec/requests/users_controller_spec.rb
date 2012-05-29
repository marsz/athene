require 'spec_helper'

describe UsersController do
  include Restable
  
  describe "blacklist" do
    before do
      @user = FactoryGirl.create :user
      @user_black = FactoryGirl.create :user_black
    end
    it "GET users#index" do
      res = request_data :get, "/users", :search => { :is_black_is_true => 1 }
      ids = res[:users].map{ |tmps| tmps[:id] }
      ids.include?(@user.id).should be_false
      ids.include?(@user_black.id).should be_true
    end
  end
end