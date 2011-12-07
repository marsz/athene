module DataMaker
  def init_all_data
    @site = Factory(:site)
    @user = Factory(:user, :site_id => @site.id)
    @post = Factory(:post, :user_id => @user.id)
    @users_monitor_parser = Factory(:users_monitor_parser, :site_id => @site.id)
    @users_monitor_url = Factory(:users_monitor_url, :site_id => @site.id, :parser_id => @users_monitor_parser.id)
  end
  
  def factory_by_domain domain
    ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/spec/lib/crawlers/#{domain}.yml"))
  end
  
end