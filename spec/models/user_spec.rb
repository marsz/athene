require 'spec_helper'

describe User do
  include DataMaker
  before do
    init_all_data
  end
  it {should belong_to(:site)}
  it {should have_many(:posts)}
  it {should validate_uniqueness_of(:site_user_id).scoped_to([:site_id])}
  it {should validate_presence_of(:site_id)}
  it {should validate_presence_of(:site_user_id)}
  
  describe "new_by_url" do
    before do
      @url = "http://www.wretch.cc/blog/venus"
      @user = User.new_by_url(@url)
    end
    it "should not null" do
      @user.nil?.should == false
      User.new_by_url("http://www.google.com").nil?.should == true
    end
    it "has site" do
      @user.site.is_a?(Site).should == true
    end
    it "should parse site_user_id" do
      @user.site_user_id.should == "venus"
    end
    it "should find exists automatically" do
      @user.new_record?.should == true
      @user.save
      User.new_by_url(@url).new_record?.should == false
    end
  end
end
