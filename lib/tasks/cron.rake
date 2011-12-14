seed_sites = [:wretch,:pixnet]
namespace :cron do
  
  task :check_users_enabled => :environment do
    User.scoped.each do |user|
      puts "check user(#{user.id}) enabled..."
      user.check_is_enabled
    end
  end
  
  namespace :builder do
    task :trigger => :environment do
      hook_key = "athene-#{Rails.env}"
      config = YAML.load_file("#{Rails.root}/config/builder.yml")[Rails.env]
      puts config.inspect
      url = "http://#{config[:host]}/hooks/build/#{hook_key}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(config[:user], config[:password])
      response = http.request(request)
    end
  end
  
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
         Site.find_by_domain(domain.to_s).users.enabled.posts_monitoring.each do |user|
           puts "monitoring user: #{user.id}...."
           # user.monitor_posts
           user.async_monitor_posts
         end
      end
    end
  end
end