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
    
    it "POST is_black" do
      res = request_data :post, "/users/#{@user.id}/is_black"
      @user.reload
      @user.is_black.should be_true
      @user.is_enabled.should be_false
    end

    it "DELETE is_black" do
      res = request_data :delete, "/users/#{@user_black.id}/is_black"
      @user.reload
      @user.is_black.should be_false
      @user.is_enabled.should be_true
    end
  end
end