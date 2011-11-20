module ActAsMonitorUsers
  extend ActiveSupport::Concern
  include ActAsFetcher
  module ClassMethods
  end
  module InstanceMethods
    def monitor_users
      users_monitor_urls.enabled.each do |users_monitor_url|
        patt = users_monitor_url.parser.to_regex
        fetch(users_monitor_url.url).scan(patt).each do |tmps|
          u = User.new_by_url(tmps[0],:name=>tmps[1])
          if u && u.new_record?
            u.save
          end
        end
        users_monitor_url.monitored
      end
    end
  end
end