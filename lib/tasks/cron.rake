seed_sites = [:wretch]
namespace :cron do
  namespace :monitor_users do
    seed_sites.each do |domain|
      task domain.to_sym => :environment do
        Site.find_by_domain(domain.to_s).monitor_users
      end
    end
  end
  namespace :monitor_posts do
    seed_sites.each do |domain|
      task domain.to_sym => :environment do
         Site.find_by_domain(domain.to_s).users.each do |user|
           user.monitor_posts
         end
      end
    end
  end
end