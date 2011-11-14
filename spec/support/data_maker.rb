module DataMaker
  def init_all_data
    @site = Factory(:site)
    @user = Factory(:user, :site_id => @site.id)
    @post = Factory(:post, :user_id => @user.id)
  end
end