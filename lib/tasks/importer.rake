namespace :importer do
  def get_site tmps
    sites = {1 => :wretch, 2 => :pixnet}
    Site.find_by_domain(sites[tmps["source_id"].to_i])
  end
  def get_user tmps, site
    User.find_by_site_user_id_and_site_id(tmps["author_key"].downcase, site.id) || User.create(:site=>site,:site_user_id=>tmps["author_key"].downcase)
  end
  def fetch url
    content = nil
    while content.nil?
      begin
         content = Net::HTTP.get(URI.parse(url))
      rescue Timeout::Error => e
         puts "refetch(#{count})!!!\n"
         content = nil
      end
    end
  end
  task :posts, :start do |t, args|
    url = "http://athene.marsz.tw/Api/Article/search.json?api_key=1234&limit=1000"
    page = args[:start] || 0
    page = page.to_i
    puts page
    keep = true
    while(keep) do
      result = ActiveSupport::JSON.decode(fetch("#{url}&page=#{page}"))
      result["data"].each do |index, tmps|
        if site = get_site(tmps)
          if user = get_user(tmps, site)
            post = Post.find_by_site_id_and_site_post_id(site.id, tmps["source_article_id"])
            if post.nil?
              post = Post.new(:user=>user,:site=>site,:site_post_id=>tmps["source_article_id"],:title=>tmps["title"],:date=>tmps["date"],:url=>tmps["url"])
              puts post.errors.full_messages.inspect if !post.save
            end
          else
            raise user.inspect
          end
        else
          raise site.inpsect
        end
        puts ((site.nil? || user.nil? || post.nil?)?  "!!!!! page: #{page}, index: #{index}" : "---- post: #{post.id}")
      end
      page += 1
    end
  end
  task :users  => :environment do
    url = "http://athene.marsz.tw/Api/User/search.json?api_key=1234&limit=1000"
    page = 1
    keep = true
    while(keep) do
      result = ActiveSupport::JSON.decode(RestClient.get("#{url}&page=#{page}"))
      result["data"].each do |index, tmps|
        if site = get_site(tmps)
          site_user_id = tmps["author_key"].downcase
          if !(user = User.find_by_site_user_id_and_site_id(site_user_id,site.id))
            user = User.create(:site => site, :site_user_id=>site_user_id)
          end
        end
        if !user
          puts "!!!!!!!! page: #{page} - index : #{index}"
        else
          puts "-------- user: #{user.id}"
        end
      end
      keep = false if result["size"] == 0
      page += 1
    end
  end
end