module ActAsReport
  extend ActiveSupport::Concern

  module ClassMethods
  end

  module InstanceMethods
    def daily_by_date date
      {
        :new_users => User.where("DATE(created_at) = ?", date).count,
        :new_posts => Post.where(:date => date).count,
        :total_users => User.scoped.count,
        :total_posts => Post.scoped.count,
        :sites => Site::CRAWLERS.map{|crawler_klass|
                    site = crawler_klass.new.seed_site
                    {:name => site.name, 
                     :total_new_users => site.users.where("DATE(created_at) = ?", date).count,
                     :total_new_posts => site.posts.where(:date=>date).count,
                     :total_users => site.users.count,
                     :total_posts => site.posts.count,
                     :monitored_users => site.users.where("DATE(monitored_at) = ?",date).count
                    }
                  }
      }
    end
  end

end