module ActAsReport
  extend ActiveSupport::Concern

  module ClassMethods
  end

  module InstanceMethods
    def daily_by_date date
      date_range = date.to_date.beginning_of_day..date.to_date.end_of_day
      {
        :new_users => User.where(:created_at => date_range).count,
        :new_posts => Post.where(:date => date).count,
        :total_users => User.scoped.count,
        :total_posts => Post.scoped.count,
        :sites => Site::CRAWLERS.map{|crawler_klass|
                    site = crawler_klass.new.seed_site
                    {:name => site.name, 
                     :total_new_users => site.users.where(:created_at => date_range).count,
                     :total_new_posts => site.posts.where(:date=>date).count,
                     :total_users => site.users.count,
                     :total_posts => site.posts.count,
                     :monitored_users => site.users.where(:monitored_at=> date_range).count
                    }
                  }
      }
    end
  end

end