require 'spec_helper'

describe Post do
  include DataMaker
  before do
    init_all_data
  end
  it {should belong_to(:site)}
  it {should belong_to(:user)}
  it {should validate_uniqueness_of(:site_post_id).scoped_to([:user_id])}
  it {should validate_presence_of(:site_id)}
  it {should validate_presence_of(:site_post_id)}
  it {should validate_presence_of(:user_id)}
  it {should validate_presence_of(:url)}
  it {should validate_presence_of(:date)}
  it {should validate_presence_of(:title)}
  
  it "sync_site_id" do
    site_another = Factory :site_another
    @post.site_id = site_another.id
    @post.save
    (@post.site_id == @site.id).should == true
  end

  describe "new_by_user" do
    before do
      @post = Post.new_by_user(@user)
    end
    it "user id match" do
      @post.user_id.should == @user.id
    end
    it "site id match" do
      @post.site_id.should == @site.id
    end
  end
  
end
