module DataMaker
  def init_all_data
    @site = Factory(:site)
    @user = Factory(:user, :site_id => @site.id)
    @post = Factory(:post, :user_id => @user.id)
    @users_monitor_parser = Factory(:users_monitor_parser, :site_id => @site.id)
    @users_monitor_url = Factory(:users_monitor_url, :site_id => @site.id, :parser_id => @users_monitor_parser.id)
  end
end