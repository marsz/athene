module DataMaker
  def init_all_data
    @site = Factory(:site, :domain => "wretch")
    @user = Factory(:user, :site_id => @site.id)
    @post = Factory(:post, :user_id => @user.id)
    @users_monitor_parser = Factory(:users_monitor_parser, :site_id => @site.id)
    @users_monitor_url = Factory(:users_monitor_url, :site_id => @site.id, :parser_id => @users_monitor_parser.id)
  end
  
  def factory_by_domain domain
    ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/spec/lib/crawlers/#{domain}.yml"))
  end
  
  def self.init_fetcher
    ActAsFetcher::InstanceMethods.module_eval do
      def fetch url, options = {}
        if !$fetch
          $fetch = {}
        end
        if !$fetch[url]
          $fetch[url] = fetch_through_medusa(url,options)["data"].to_s
        end
        $fetch[url]
      end
      
      def fetch_status url, options = {}
        if !$fetch_status
          $fetch_status = {}
        end
        if !$fetch_status[url]
          $fetch_status[url] = fetch_through_medusa(url,options)["status"]
        end
        $fetch_status[url]
      end
    end
  end
  
end